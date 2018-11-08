class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.6/wesnoth-1.12.6.tar.bz2"
  sha256 "a50f384cead15f68f31cfa1a311e76a12098428702cb674d3521eb169eb92e4e"
  revision 8
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "c1e57e9db734dae8894f25fbb2ca6668abec294af98033558e047e76c47db873" => :mojave
    sha256 "ea1c1b9370dc86ac25a846958ecac6a731f82d79b1743de3b541fdb9111c32c6" => :high_sierra
    sha256 "824680767e435b633e49a7ede3a4115babace30298a5c1842ee782c686ff7d74" => :sierra
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
