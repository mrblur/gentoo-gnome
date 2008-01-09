# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/eel/eel-2.20.0.ebuild,v 1.7 2007/11/29 05:24:15 jer Exp $

inherit virtualx gnome2

DESCRIPTION="The Eazel Extentions Library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.15
		 >=x11-libs/gtk+-2.10
		 >=gnome-base/gail-0.16
		 >=gnome-base/gconf-2.0
		 >=dev-libs/libxml2-2.4.7
		 >=gnome-base/libglade-2.0
		 >=gnome-base/gnome-desktop-2.21.3
		 >=x11-libs/startup-notification-0.8

		 >=gnome-base/libgnome-2.0
		 >=gnome-base/libgnomeui-2.8"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README THANKS TODO"

src_test() {
	if hasq userpriv $FEATURES; then
		einfo "Not running tests without userpriv"
	else
		addwrite "/root/.gnome2"
		Xmake check || die "make check failed"
	fi
}
