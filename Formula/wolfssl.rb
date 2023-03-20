class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.5.4-stable",
      revision: "4fbd4fd36a21efd9d1a7e17aba390e91c78693b1"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2ccddad1acdf1105dbaed9cd32db6e90bcc3bf9ac70463d9e4968e422e2124e"
    sha256 cellar: :any,                 arm64_monterey: "1f760132a18a485463249b956aead7dff81350f3a7862f32237b601f04c24a75"
    sha256 cellar: :any,                 arm64_big_sur:  "756febdd139b6defbf5f13e7f65d7cdd11282ec2e18a0023a1e352abf34d6835"
    sha256 cellar: :any,                 ventura:        "5b6e253e9f599fdf504ee1c1872241761fd67128ee90e773949f91cf225a9633"
    sha256 cellar: :any,                 monterey:       "3ffebf52d9dc71d3df3c5615c450b15c9c920f45d131b027842144925167b9a7"
    sha256 cellar: :any,                 big_sur:        "3fba6d0dd014e84e8938735c2d231db1b1735a7c9d1285ba9afa293b22c2e338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd1c01cc9e3679f54ba73ecf96f08b165f0bf338edd4cd82a15ecc2f2948946"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
      --enable-hc128
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
      --enable-rabbit
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
