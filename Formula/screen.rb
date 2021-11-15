class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"
  license "GPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.8.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.8.0.tar.gz"
    sha256 "6e11b13d8489925fde25dfb0935bf6ed71f9eb47eff233a181e078fde5655aa1"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 arm64_monterey: "ecc1aea0ba2f09f1aced218c50e77ac8d844eb7536ad6825838f1b0140662f2f"
    sha256 arm64_big_sur:  "8ba1521db91bbc7fe1852d22c56b1de1c14e93fd8d4510b627948b211ee90f77"
    sha256 monterey:       "ca5548e901ed578eab81a3b935e82c713951e5526ed6e8ddeb3a65972cf24755"
    sha256 big_sur:        "6a4935174331a3d96eb0fb5e05af4a095d188565f5f87d7e6dbf6a8478490644"
    sha256 catalina:       "f3787a0e1c889106ab14d89c4f1bed001716ce1eb79e44e56b20e71b7448e172"
    sha256 mojave:         "30dfe7b1bc6c74d64be57224852e50ebd5d4c6d4939872eaceac5f06d9935208"
    sha256 high_sierra:    "1e63b4fd4ae798111980a7d9ed47c3fcb867cbad2c4253164b55722efc65d53e"
    sha256 x86_64_linux:   "a9c0638b44b8fc6852effac19a000d7f75f5901631e5336891e805b969e34145"
  end

  head do
    url "https://git.savannah.gnu.org/git/screen.git"

    depends_on "autoconf@2.69" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    if build.head?
      cd "src"
      system "./autogen.sh"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    # Fix error: dereferencing pointer to incomplete type 'struct utmp'
    ENV.append_to_cflags "-include utmp.h"

    # Fix for Xcode 12 build errors.
    # https://savannah.gnu.org/bugs/index.php?59465
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256",
                          "--enable-pam"

    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
