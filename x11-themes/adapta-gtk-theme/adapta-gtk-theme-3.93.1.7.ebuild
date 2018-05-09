# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An adaptive Gtk+ theme based on Material Design Guidelines"
HOMEPAGE="https://github.com/adapta-project/adapta-gtk-theme"
LICENCE="GPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="gnome cinnamon xfce mate openbox parallel fonts"
KEYWORDS="-* ~amd64 ~x86"
RDEPEND=">=x11-libs/gtk+-3.20.0:3
	>=x11-libs/gtk+-2.24.30:2
	>=x11-themes/gtk-engines-murrine-0.98.1
	fonts? ( media-fonts/roboto )
	gnome? ( >=gnome-base/gnome-shell-3.20.0 )
	cinnamon? ( >=gnome-extra/cinnamon-2.8.6 )
	xfce? ( >=xfce-base/xfce4-meta-4.12.2 )
	mate? ( >=mate-base/mate-1.14.0 )
"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2
	>=sys-devel/automake-1.9
	>=media-gfx/inkscape-0.91
	>=x11-libs/gdk-pixbuf-2.32.2
	>=dev-libs/glib-2.48
	>=dev-libs/libsass-3.3
	>=dev-lang/sassc-3.3
	>=dev-libs/libxml2-2.9.6
	parallel? ( sys-process/parallel )
"
	
SRC_URI=https://github.com/adapta-project/adapta-gtk-theme/archive/${PV}.tar.gz

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable parallel) \
		$(use_enable gnome) \
		$(use_enable cinnamon) \
		$(use_enable xfce) \
		$(use_enable mate) \
		$(use_enable openbox) 
}


