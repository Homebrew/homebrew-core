class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.8.1.tar.bz2"
  sha256 "d9af70acea5c054952ad1584916c1bf231b064eb6c8a9791dcb6ae90a769990c"

  bottle do
    sha256 "8f7f09871c02f3f2496f2976f9d34848bb1b7b5bd3e4f150cd07071562b101a2" => :catalina
    sha256 "55fb8c18db540ebc3584c2a573da498ba632a07169d9cf2bac3320b3c8916486" => :mojave
    sha256 "ed0e26a2d7ff1a96f7eded1f873061acde87483dce89951c450dac9b57e2be61" => :high_sierra
    sha256 "ee8dcf5d43f859849188785a0ef2b8dca54f26e5f0e95c292507ba449ea0426e" => :sierra
  end

  head do
    url "https://git.strongswan.org/strongswan.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "openssl@1.1"

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
      --enable-kernel-pfroute
      --enable-nonce
      --enable-openssl
      --enable-osx-attr
      --enable-pem
      --enable-pgp
      --enable-pkcs1
      --enable-pkcs8
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

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<~EOS
    You will have to run both "ipsec" and "charon-cmd" with "sudo".
  EOS
  end

  test do
    system "#{bin}/ipsec", "--version"
    system "#{bin}/charon-cmd", "--version"
  end
end
