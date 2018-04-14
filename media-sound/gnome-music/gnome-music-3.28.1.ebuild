# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit meson gnome2

DESCRIPTION="Simple music player"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
SRC_URI="https://download.gnome.org/sources/gnome-music/3.28/${P}.tar.xz"

RDEPEND="
	>=dev-python/pycairo-1.14
	>=dev-python/pygobject-3.21.1
	>=x11-libs/gtk+-3.19.3
	>=media-libs/libmediaart-1.9.1
	>=app-misc/tracker-1.99.1
	>=dev-libs/gobject-introspection-1.35
	>=media-libs/grilo-0.3.4
"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.40.0
	doc? ( dev-util/gtk-doc )
	>=dev-util/ninja-1.7
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure \
		$(meson_use doc enable-gtk-doc) \
		-Denable-introspection=true
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
