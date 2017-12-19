class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.6/wesnoth-1.12.6.tar.bz2"
  sha256 "a50f384cead15f68f31cfa1a311e76a12098428702cb674d3521eb169eb92e4e"
  revision 5
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "e3bc1012dacb4eed458f7ac65dafbea0b953c0434928b89f12a469360ecb9828" => :high_sierra
    sha256 "2ef2d6ab76e861711ca5d5f307e9771eb0fa3d0235f9ee9236b95864db1801e0" => :sierra
    sha256 "8878bacb681b332d3ae2d08a106692166d1d4cb7056b713f9613368303f1fd74" => :el_capitan
    sha256 "4802ef4287047c312dbb433e57a474ec0dc4040d1f15275c0f7514090fb2cbc7" => :yosemite
  end

  option "with-ccache", "Speeds recompilation, convenient for beta testers"
  option "with-debug", "Build with debugging symbols"

  depends_on "scons" => :build
  depends_on "gettext" => :build
  depends_on "ccache" => :optional
  depends_on "fribidi"
  depends_on "boost"
  depends_on "libpng"
  depends_on "fontconfig"
  depends_on "cairo"
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
    args << "ccache=true" if build.with? "ccache"
    args << "build=debug" if build.with? "debug"

    scons *args
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
