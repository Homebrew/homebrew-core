class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"
  license "GPL-3.0-or-later"
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
    sha256 arm64_monterey: "fe5385e7a06b3b3c7b619979a2506ab727c0c2abc0f69eba749fe9f737a934ac"
    sha256 arm64_big_sur:  "b6cf1074628d7dbbf2fd816234c666f56f2a4f0a58f6ec5d6cce97fd4d0150b1"
    sha256 monterey:       "7df16eac999996ffccb6215a711039ccac9e4a7b576a3ae07b90be855bd017c0"
    sha256 big_sur:        "8d4a322e94a212359803fb59f0dd306fda8baf7ae825e47dee1f307feb0dfb43"
    sha256 catalina:       "3d60abe23c16c832fab478a211305c30e86f19e3d859d19f5855b3ab21dd0082"
    sha256 x86_64_linux:   "2b36866a15b6811d4682815c4d446e05c93cad630f1ad3ca2b97e7589429b81c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
