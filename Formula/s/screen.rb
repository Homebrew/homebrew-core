class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.9.1.tar.gz"
    sha256 "26cef3e3c42571c0d484ad6faf110c5c15091fbf872b06fa7aa4766c7405ac69"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "7eb9de9e4d0e2afb4c4ae8f243a680195a407ff90b52a621bc6381b949175890"
    sha256 arm64_ventura:  "04ad8f56bd2779a33507db4dc0c4d2bde8adf55c55f498a73b958a6d284480a4"
    sha256 arm64_monterey: "95c6ca795cac6af997554d8516cd1ff33bd4bd60987a988e298c33671743a422"
    sha256 arm64_big_sur:  "d16af53c7667ddb58d38ec09bcd410824d05df09d18a30e368856df2e0970a6f"
    sha256 sonoma:         "9cfcc7667c004261be837a37d3a3cbe8ea445e114a323f5498f1abc7ae016b9e"
    sha256 ventura:        "946970f422fa285f5a3154612630444e98a6a7bcc7579caf174b13456b16664c"
    sha256 monterey:       "8fa812527fbbe1786423f29310caa993858b7bd5b95922aca7713078135397b4"
    sha256 big_sur:        "7d5f4d3be91c4aec072defd3fb083fd38dc56e9ba111e7acaab15e71ae073ad9"
    sha256 x86_64_linux:   "576d96f72e6e6a6b533adb65a016cf068bf97937baff72fbf7b4beec1f5e3c3d"
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
