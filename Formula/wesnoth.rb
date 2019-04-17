class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.6/wesnoth-1.12.6.tar.bz2"
  sha256 "a50f384cead15f68f31cfa1a311e76a12098428702cb674d3521eb169eb92e4e"
  revision 9
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "6769f6bf00f1cdc322306309ec61292934069268e54f046fffadd9ed7b32a1a9" => :mojave
    sha256 "8dd31558084552d40010d6972294c9c4c5f36e858e5ad6295ce907b8c8118e25" => :high_sierra
    sha256 "d5a18a191a86809322685525857ffc206cd28eff10cf1af25d38836c08263762" => :sierra
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

    system "scons", *args
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
