class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.8.0-stable",
      revision: "b077c81eb635392e694ccedbab8b644297ec0285"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efc64785e620d8b1c5e208b99fe2a236b945cdbb777fe5af8284b43c08f48e84"
    sha256 cellar: :any,                 arm64_sonoma:  "4ee88f3a4c99780161ac2c928ebd0d01dc87207eaa0604425a1f3b474fe1619e"
    sha256 cellar: :any,                 arm64_ventura: "8e651bbeb00f69694557d26ad4e59c5c83c6f17ec614fc18f6355e33213c5d5f"
    sha256 cellar: :any,                 sonoma:        "c4e4c1deb606b4eac0534ff557ea62e761a82b9cdc03b49d745155b5d3c206c6"
    sha256 cellar: :any,                 ventura:       "436ff4612e6a9c04aee827ca18e267313826b9977916e2e8a3355c3fdc4e61ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac5f9b9f00adec84003757ac0c3cc39ea4afa512b889af0d6274d8a9774ba29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2eada4b8e21f9f2b033159dca61c0f0b00be104b8458c0cd6ccd4e270ee4e2e"
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
