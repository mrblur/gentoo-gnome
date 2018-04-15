# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit autotools bash-completion-r1 eutils gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="cue elibc_glibc exif ffmpeg firefox-bookmarks flac gif gsf gstreamer gtk
iptc +iso +jpeg kernel_linux libav +miner-fs mp3 networkmanager pdf
playlist rss stemmer test thunderbird +tiff upnp-av upower +vorbis +xml xmp
xps"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	cue? ( gstreamer )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !gsf !iptc !iso !jpeg !mp3 !pdf !playlist !tiff !vorbis !xml !xmp !xps )
"

# According to NEWS, introspection is non-optional
# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
RDEPEND="
	>=app-i18n/enca-1.9
	>dev-db/sqlite-3.8.4.2:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=media-libs/libpng-1.2:0=
	>=media-libs/libmediaart-1.9:2.0
	>=x11-libs/pango-1:=
	sys-apps/util-linux
	virtual/imagemagick-tools[png,jpeg?]

	cue? ( app-misc/tracker-miners )
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? ( app-misc/tracker-miners )
	firefox-bookmarks? ( app-misc/tracker-miners )
	flac? ( app-misc/tracker-miners )
	gif? ( app-misc/tracker-miners )
	gsf? ( app-misc/tracker-miners )
	gstreamer? ( app-misc/tracker-miners )
	gtk? (
		>=dev-libs/libgee-0.3:0.8
		>=x11-libs/gtk+-3:3 )
	iptc? ( app-misc/tracker-miners )
	iso? ( >=sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	kernel_linux? ( >=sys-libs/libseccomp-2.0.0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( app-misc/tracker-miners )
	networkmanager? ( >=net-misc/networkmanager-0.8:= )
	pdf? ( app-misc/tracker-miners )
	playlist? ( app-misc/tracker-miners )
	rss? ( app-misc/tracker-miners )
	stemmer? ( dev-libs/snowball-stemmer )
	thunderbird? ( app-misc/tracker-miners )
	tiff? ( app-misc/tracker-miners )
	upnp-av? ( app-misc/tracker-miners )
	vorbis? ( app-misc/tracker-miners )
	xml? ( app-misc/tracker-miners )
	xmp? ( app-misc/tracker-miners )
	xps? ( app-misc/tracker-miners )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	gtk? ( >=dev-libs/libgee-0.3:0.8 )
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"
PDEPEND=""

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	eautoreconf # See bug #367975
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myconf=""

	gnome2_src_configure \
		--disable-static \
		--enable-introspection \
		--enable-tracker-fts \
		--with-unicode-support=libicu \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		$(use_enable upower upower) \
		$(use_enable networkmanager network-manager) \
		$(use_enable stemmer libstemmer) \
		$(use_enable test functional-tests) \
		$(use_enable test unit-tests) \
		${myconf}
}

src_test() {
	# G_MESSAGES_DEBUG, upstream bug #699401#c1
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session" G_MESSAGES_DEBUG="all"
}

src_install() {
	gnome2_src_install
}
