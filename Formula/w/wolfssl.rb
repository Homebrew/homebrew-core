class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.9.2-stable",
      revision: "ac01707f552c611fbd135cc723b2682b3e7f80f2"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "92851dd6eb8e88140f5749104c1e5264f5af8bf597c8d35d44dd27bb5c327f29"
    sha256 cellar: :any, arm64_sequoia: "862ebf92fdf078505b5d88eedc329cc95ddd72072b93dd6ca9944ddc2e26c15b"
    sha256 cellar: :any, arm64_sonoma:  "4ca7786140c7c3147b7fdd403a8862ea85cd9c40ca5b515c266e104085eb7044"
    sha256 cellar: :any, sonoma:        "b8f6e4be279f6d7eca0bd5d21a7a4d9ffd5e0d069fc3cd11d75861676b4f719e"
    sha256 cellar: :any, arm64_linux:   "d2530699eb54a17fb16538600911c76009cae5a0197e99cebcb3961a2ecae995"
    sha256 cellar: :any, x86_64_linux:  "80946a9f3733d3cbdea19d95b6e64f5b91c8322e0a72b22a24d8dc9282470b4f"
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
