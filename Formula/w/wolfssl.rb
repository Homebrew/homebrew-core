class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.9.0-stable",
      revision: "922d04b3568c6428a9fb905ddee3ef5a68db3108"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0aa9a866c469c80c891e1e381049e226b257735cf6425f8e1bd2685966ed7ced"
    sha256 cellar: :any,                 arm64_sequoia: "d27328c5c3061094e185621c87b3f722c6d3ea91308a56642c841344467eaa0a"
    sha256 cellar: :any,                 arm64_sonoma:  "f692466f4bbfd3adaad0c45e23287a68ec6e357051bd3dae8d88e820ffc471cb"
    sha256 cellar: :any,                 sonoma:        "c62b566c168221f9d7d6ef9e90fb9290b288d774166352ed367cb4d72d9890e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f83ac0fa853e2cd750f561cf424c697dc405af38e08d3fe528c55131d133f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daccc374ef8a3d113495cf631edd89b6f5800f377d415fdd690377c11a8c8920"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --infodir=#{info}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-earlydata
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-silent-rules
      --disable-sniffer
      --disable-webserver
      --enable-all
      --enable-reproducible-build
    ]

    # https://github.com/wolfSSL/wolfssl/issues/8148
    args << "--disable-armasm" if OS.linux? && Hardware::CPU.arm?

    # Extra flag is stated as a needed for the Mac platform.
    # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if OS.mac?

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
