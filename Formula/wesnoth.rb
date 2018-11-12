class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.14/wesnoth-1.14.5/wesnoth-1.14.5.tar.bz2"
  sha256 "05317594b1072b6cf9f955e3a7951a28096f8b1e3afed07825dd5a219c90f7cd"
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "c1e57e9db734dae8894f25fbb2ca6668abec294af98033558e047e76c47db873" => :mojave
    sha256 "ea1c1b9370dc86ac25a846958ecac6a731f82d79b1743de3b541fdb9111c32c6" => :high_sierra
    sha256 "824680767e435b633e49a7ede3a4115babace30298a5c1842ee782c686ff7d74" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "openssl"
  depends_on "pango"
  depends_on "sdl2"
  depends_on "sdl2_image" # Must have png support
  depends_on "sdl2_mixer" # The music is in .ogg format
  depends_on "sdl2_ttf"

  def install
    scons "prefix=#{prefix}", "docdir=#{doc}", "mandir=#{man}",
      "fifodir=#{var}/run/wesnothd",
      "gettextdir=#{Formula["gettext"].opt_prefix}",
      "extra_flags_config=-I#{Formula["openssl"].opt_include} -L#{Formula["openssl"].opt_lib}",
      "OS_ENV=true", "install", "wesnoth", "wesnothd", "-j#{ENV.make_jobs}"
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
