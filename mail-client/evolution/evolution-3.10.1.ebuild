# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic readme.gentoo gnome2 versionator
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi
MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="https://live.gnome.org/Evolution http://projects.gnome.org/evolution/"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"
IUSE="+bogofilter crypt gstreamer highlight kerberos ldap map spamassassin ssl +weather"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gtk] app-crypt/pinentry-qt app-crypt/pinentry[qt4] )"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
COMMON_DEPEND="
	>=dev-libs/glib-2.34:2
	>=x11-libs/cairo-1.9.15:=[glib]
	>=x11-libs/gtk+-3.4.0:3
	>=x11-libs/gdk-pixbuf-2.24
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=media-libs/libcanberra-0.25[gtk3]
	>=x11-libs/libnotify-0.7:=
	>=gnome-extra/evolution-data-server-${PV}:=[weather?]
	=gnome-extra/evolution-data-server-${MY_MAJORV}*
	>=gnome-extra/gtkhtml-4.5.2:4.0
	dev-libs/atk
	>=dev-libs/dbus-glib-0.6
	>=dev-libs/libxml2-2.7.3:2
	>=net-libs/libsoup-2.43:2.4
	>=x11-misc/shared-mime-info-0.22
	>=x11-themes/gnome-icon-theme-2.30.2.1
	>=net-libs/webkit-gtk-1.10.0

	x11-libs/libSM
	x11-libs/libICE

	crypt? ( || (
		( >=app-crypt/gnupg-2.0.1-r2 ${PINENTRY_DEPEND} )
		=app-crypt/gnupg-1.4* ) )
	map? (
		>=app-misc/geoclue-0.12.0
		>=media-libs/libchamplain-0.12:0.12
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		>=sci-geosciences/geocode-glib-0.99.0
		x11-libs/mx:1.0 )
	gstreamer? ( || (
		 ( media-libs/gstreamer:1.0
		   media-libs/gst-plugins-base:1.0 )
		 ( media-libs/gstreamer:0.10
		   media-libs/gst-plugins-base:0.10 )
	) )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	ssl? (
		>=dev-libs/nspr-4.6.1:=
		>=dev-libs/nss-3.11:= )
	weather? ( >=dev-libs/libgweather-3.5.0:2= )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"
# eautoreconf needs:
#	app-text/yelp-tools
#	>=gnome-base/gnome-common-2.12
RDEPEND="${COMMON_DEPEND}
	bogofilter? ( mail-filter/bogofilter )
	highlight? ( app-text/highlight )
	spamassassin? ( mail-filter/spamassassin )
	!<gnome-extra/evolution-exchange-2.32
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools
		doc? ( >=dev-util/gtk-doc-1.14 )"
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To change the default browser if you are not using GNOME, edit
~/.local/share/applications/mimeapps.list so it includes the
following content:

[Default Applications]
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop

(replace firefox.desktop with the name of the appropriate .desktop
file from /usr/share/applications if you use a different browser)."

src_prepare() {
	# Use webkit_dom_element_get_id:
	# https://bugzilla.gnome.org/show_bug.cgi?id=707112
	epatch "${FILESDIR}"/evolution-3.10.0-use-webkit-dom-element-get-set-id.patch

	# Link libevolution-mail-formatter.la to evolution-alarm-notify
	# https://bugzilla.gnome.org/show_bug.cgi?id=710852
	epatch "${FILESDIR}"/evolution-3.10.1-alarm-notify-depends-on-mail-formatter.patch

	# Port contact map to geocode-glib >= 0.99.1
	# https://bugzilla.gnome.org/show_bug.cgi?id=689055
	# https://github.com/Heather/gentoo-gnome/issues/33
	epatch "${FILESDIR}"/evolution-3.10.1-port-contact-map-to-geocode-3.10.patch

	ELTCONF="--reverse-deps"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"

	eautoreconf # See https://bugzilla.gnome.org/701904

	gnome2_src_prepare

	# Fix compilation flags crazyness
	sed -e 's/\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure || die "CPPFLAGS sed failed"
}

src_configure() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	# image-inline plugin needs a gtk+:3 gtkimageview, which does not exist yet
	local myconf
	[[ ${PV} != 9999 ]] && myconf="${myconf} ITSTOOL=$(type -P true)"
	gnome2_src_configure \
		--disable-schemas-compile \
		--without-glade-catalog \
		--disable-image-inline \
		--disable-pst-import \
		--enable-canberra \
		$(use_enable bogofilter) \
		$(use_enable gstreamer audio-inline) \
		$(use_enable highlight text-highlight) \
		$(use_enable map contact-maps) \
		$(use_enable spamassassin) \
		$(use_enable ssl nss) \
		$(use_enable ssl smime) \
		$(use_with kerberos krb5 "${EPREFIX}"/usr) \
		$(use_with ldap openldap) \
		$(usex ssl --enable-nss=yes "--without-nspr-libs
			--without-nspr-includes
			--without-nss-libs
			--without-nss-includes") \
		$(use_enable weather) \
		${myconf}
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
