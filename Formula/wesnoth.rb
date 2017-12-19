class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.6/wesnoth-1.12.6.tar.bz2"
  sha256 "a50f384cead15f68f31cfa1a311e76a12098428702cb674d3521eb169eb92e4e"
  revision 5
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "96702926477901a94004066eba549037f093d3f2052b5ea0b737b9758cb8f484" => :high_sierra
    sha256 "595dbaf29981f9db172e554f9c8e19842bbadc24d1b8e47d88221cdf368ebfad" => :sierra
    sha256 "cd5af25e6a09b9e0e3230775732e2dcfd41ebe4f6a2e53c535c6b72ed7e54922" => :el_capitan
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
