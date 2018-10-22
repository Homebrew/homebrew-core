class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.14/wesnoth-1.14.5/wesnoth-1.14.5.tar.bz2"
  sha256 "05317594b1072b6cf9f955e3a7951a28096f8b1e3afed07825dd5a219c90f7cd"
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "415c02b6c6ff9664fb11f41ff9a7441356b3fb70eb4efc1d9dd21c3a9de7b370" => :high_sierra
    sha256 "d1440a43271ccec672400bd6daefae1c448da134c35d4c282dffa038e934ed33" => :sierra
    sha256 "f4de6ae40204fa43e16e0a970e508d7b9869965b06b1170e3a8b1c935f187c9c" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "libpng"
  depends_on "pango"
  depends_on "sdl"
  depends_on "sdl_image" # Must have png support
  depends_on "sdl_mixer" # The music is in .ogg format
  depends_on "sdl_net"
  depends_on "sdl_ttf"

  def install
    mv "scons/gettext.py", "scons/gettext_tool.py"
    inreplace "SConstruct", ", \"gettext\",", ", \"gettext_tool\","

    args = %W[prefix=#{prefix} docdir=#{doc} mandir=#{man} fifodir=#{var}/run/wesnothd gettextdir=#{Formula["gettext"].opt_prefix}]
    args << "OS_ENV=true"
    args << "install"
    args << "wesnoth"
    args << "wesnothd"
    args << "-j#{ENV.make_jobs}"

    scons *args
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
