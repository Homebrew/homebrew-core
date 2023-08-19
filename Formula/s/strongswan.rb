class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.9.11.tar.bz2"
  sha256 "ddf53f1f26ad26979d5f55e8da95bd389552f5de3682e35593f9a70b2584ed2d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2b1219062863292dbef4f3f933e16d7aa3feabbf56b079ead071cf56e7053845"
    sha256 arm64_monterey: "b04332084ea2af50fe70147a08e982b79796855dcc8307388fe705b12d1108cf"
    sha256 arm64_big_sur:  "9a5d7e064037e45a0c757c7bf6bef071bb67e49535a378b435cc94aa9cf1d237"
    sha256 ventura:        "d032b3fd78f264a263df8a727fcf3fa295367f1ff6e9a390744ce3b6d82d91b9"
    sha256 monterey:       "493f85fc3ad7ef41e3b4204c4b531630fd4b68c3c33fb27bdb8d6bbccea17df0"
    sha256 big_sur:        "6e5e0ef6136512f86b4bb94b39b5444149efabe8cea354654f6ba15e0544290a"
  end

  head do
    url "https://github.com/strongswan/strongswan.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "openssl@3"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --disable-defaults
      --enable-charon
      --enable-cmd
      --enable-constraints
      --enable-curve25519
      --enable-eap-gtc
      --enable-eap-identity
      --enable-eap-md5
      --enable-eap-mschapv2
      --enable-ikev1
      --enable-ikev2
      --enable-kernel-pfkey
      --enable-nonce
      --enable-openssl
      --enable-pem
      --enable-pgp
      --enable-pkcs1
      --enable-pkcs8
      --enable-pkcs11
      --enable-pki
      --enable-pubkey
      --enable-revocation
      --enable-scepclient
      --enable-socket-default
      --enable-sshkey
      --enable-stroke
      --enable-swanctl
      --enable-unity
      --enable-updown
      --enable-x509
      --enable-xauth-generic
    ]

    args << "--enable-kernel-pfroute" << "--enable-osx-attr" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
  end

  test do
    system "#{bin}/ipsec", "--version"
    system "#{bin}/charon-cmd", "--version"
  end
end
