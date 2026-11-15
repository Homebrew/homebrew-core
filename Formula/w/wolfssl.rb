class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.9.4-stable",
      revision: "3c5eead44904df64e6a5a1f4ebdce377d35a849a"
  license "GPL-3.0-or-later"
  compatibility_version 2
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b20e22f4a91be3dc7adc6c4184c849f362e6df84168b1aa199938f78fe1d460b"
    sha256 cellar: :any, arm64_tahoe:       "2d20992bcf519985e1fc216362f4312deacc7248f72207afa7b18bd20a95c8cf"
    sha256 cellar: :any, arm64_sequoia:     "bb1007a3549020c942f1205abec2b8d22dc10519c56e939841cd2e5290acc8ef"
    sha256 cellar: :any, arm64_linux:       "6bafae64a9a2606037b56a086df814ed4d78ce0236c81ffe2b4500f951cf8bc6"
    sha256 cellar: :any, x86_64_linux:      "0cfd5b000ec77c9b22edaccbe54e665a3eec50857ebcae2cbd3142a24f3069ce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

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
