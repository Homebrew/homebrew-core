class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.14/wesnoth-1.14.2/wesnoth-1.14.2.tar.bz2"
  sha256 "282bb551f0e1679a2c09938c0bbae1cb13e54851cead5c7b425b7ec4648716f6"

  bottle do
    sha256 "415c02b6c6ff9664fb11f41ff9a7441356b3fb70eb4efc1d9dd21c3a9de7b370" => :high_sierra
    sha256 "d1440a43271ccec672400bd6daefae1c448da134c35d4c282dffa038e934ed33" => :sierra
    sha256 "f4de6ae40204fa43e16e0a970e508d7b9869965b06b1170e3a8b1c935f187c9c" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "libpng"
  depends_on :macos => :sierra
  depends_on "openssl"
  depends_on "pango"
  depends_on "sdl2"
  depends_on "sdl2_image" # Must have png support
  depends_on "sdl2_mixer" # The music is in .ogg format
  depends_on "sdl2_net"
  depends_on "sdl2_ttf"

  def install
    scons "prefix=#{prefix}", "docdir=#{doc}", "mandir=#{man}",
          "fifodir=#{var}/run/wesnothd",
          "gettextdir=#{Formula["gettext"].opt_prefix}",
          "extra_flags_config=-I#{Formula["openssl"].opt_include}",
          "OS_ENV=true", "install", "wesnoth", "wesnothd", "-j#{ENV.make_jobs}"
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
