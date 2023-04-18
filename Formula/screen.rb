class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.9.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.9.0.tar.gz"
    sha256 "f9335281bb4d1538ed078df78a20c2f39d3af9a4e91c57d084271e0289c730f4"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 arm64_ventura:  "710010dcc95e1c009e74900645ed999f5061468be5d6d8132e858218ed9c4b9f"
    sha256 arm64_monterey: "82681e96492eee0fcc3bb05fc35bb9c851863977661f0cb82e8566e9e00281ab"
    sha256 arm64_big_sur:  "db92cc1e9676ee7395909eec825d41ea84812e6190583e220f9ee252ec13499c"
    sha256 ventura:        "7d57b0e3d553434da8944818f44a0795400ad7047861b7bb13ca4b23027297a0"
    sha256 monterey:       "a20516f42dece533dde56d54b7a23d48f8dcb15532fb8645939e3585ef744e8e"
    sha256 big_sur:        "458a2df89e572e2b3d058881f843965dc45c5a2dedeebeb1ebfbd0aa6c8297be"
    sha256 x86_64_linux:   "37add3e97f6ba3316be8b920dd6a41089b095c5e8a3fb4b3a5e64cf98c98b0ef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    cd "src" if build.head?

    # Fix error: dereferencing pointer to incomplete type 'struct utmp'
    ENV.append_to_cflags "-include utmp.h"

    # Fix for Xcode 12 build errors.
    # https://savannah.gnu.org/bugs/index.php?59465
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # master branch configure script has no
    # --enable-colors256, so don't use it
    # when `brew install screen --HEAD`
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--infodir=#{info}",
      "--enable-pam",
    ]
    args << "--enable-colors256" unless build.head?

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system bin/"screen", "-h"
  end
end
