class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "http://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.4/wesnoth-1.12.4.tar.bz2"
  sha256 "bf525060da4201f1e62f861ed021f13175766e074a8a490b995052453df51ea7"

  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "63250b3eefb3ff93eba14addee9acfb6980ba138b9033b824a14f5e2a3a5a4b0" => :yosemite
    sha256 "93e971f838ba9c2bf97974dc3ef7d6823138bdda560671d67cf74794d65c4f30" => :mavericks
    sha256 "dcbc0e81cd0a5c92392b51b1e68f933045277bf75eeddebaa3b99797c45ce6be" => :mountain_lion
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
  depends_on "sdl_mixer" => "with-libvorbis" # The music is in .ogg format
  depends_on "sdl_net"
  depends_on "sdl_ttf"

  def install
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
