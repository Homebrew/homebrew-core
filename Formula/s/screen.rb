class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen/"
  url "https://ftpmirror.gnu.org/screen/screen-5.0.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/screen/screen-5.0.3.tar.gz"
  sha256 "941c98ffecdca4bff4bbd1cd6f08fbd18967353affc46521040a999dafbd39a2"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  bottle do
    manifest_sha256 "5c0d208ebe7794338d06ba98d6042dd85dd7d3b2bab4c57ced006728650baaf3"
    sha256 arm64_golden_gate: "269055c0c68e1bcc34e6e9501ec711074934e537965283b78db31cc81c2d4da2"
    sha256 arm64_tahoe:       "64ac04d0bbc141a1424f529e21511eec9cfbbf90d9bd87659c1bbc9672754b65"
    sha256 arm64_sequoia:     "519f0d0865921dab35af21b3dadc359e6e5fb6ec80a86f70aa65eb24e1df7abb"
    sha256 arm64_linux:       "ca5eecde146d1e0e3eced6a7e81a0f853ce5a199f95bf4ed9c709da073a6c273"
    sha256 x86_64_linux:      "0d59f6f810d3302b8ffb1ef1b4e1e79d585369dcedaaf87252c7160e0b1a63f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "linux-pam"
  end

  deny_network_access!

  def install
    args = %W[
      --mandir=#{man}
      --infodir=#{info}
      --enable-pam
    ]

    system "./autogen.sh"

    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", *args, *std_args
    system "make", "install"
  end

  test do
    system bin/"screen", "-h"
  end
end
