class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.7.2-stable",
      revision: "00e42151ca061463ba6a95adb2290f678cbca472"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5278c9a7db3c9e785a8d3b2ab7a1e6cc29200aa614eaf1b598ceddc724b3a5d"
    sha256 cellar: :any,                 arm64_ventura:  "20f2ec33f81043bb963967bb298ded454d43838e59fcd157eacea4d6727bb24f"
    sha256 cellar: :any,                 arm64_monterey: "81df63bf44a68a030d5d4b9bfa5bec852b6aa12bd87c235bc2f68ee76b3d4725"
    sha256 cellar: :any,                 sonoma:         "f7d9057453252e1eb7f747b04684b4157e9aaecd9edf9d8f29fb0f5ce1e75dc0"
    sha256 cellar: :any,                 ventura:        "83b42519303c99aec3d03bf33848d7232419221038c2877fdb4e0b5ae0055a57"
    sha256 cellar: :any,                 monterey:       "7549e87a7899d14031dd50889f503b37fa3d27edd1e3f96b3b1ab99e8c0d01f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b1cab01b0ec8c70155029061afb26ee73e759ca7a27b24474b7a24e3b53a79"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-linux" => :build

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-aesgcm-stream
      --enable-alpn
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-curve25519
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ed25519
      --enable-filesystem
      --enable-hkdf
      --enable-inline
      --enable-ipv6
      --enable-jni
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-quic
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
      --enable-tls13
      --enable-sp
      --enable-fastmath
      --enable-fasthugemath
    ]

    if OS.mac?
      # Extra flag is stated as a needed for the Mac platform.
      # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
      # Also, only applies if fastmath is enabled.
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
