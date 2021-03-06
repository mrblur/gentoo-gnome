# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.34

inherit gnome2-utils vala cmake-utils git-r3

DESCRIPTION="A lightweight and stylish app launcher for Pantheon and other DEs"
HOMEPAGE=" https://github.com/elementary/applications-menu"
EGIT_REPO_URI=" https://github.com/elementary/applications-menu.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

RDEPEND="
	dev-libs/appstream[vala]
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	gnome-base/gnome-menus:3
	net-libs/libsoup:2.4
	>=dev-libs/granite-0.3
	x11-libs/gtk+:3
	gnome-extra/zeitgeist
	pantheon-base/wingpanel
	>=pantheon-base/switchboard-2"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.34.8
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	eapply_user

	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DICONCACHE_UPDATE=OFF
		-DUSE_UNITY=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
