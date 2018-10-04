class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.7.1.tar.bz2"
  sha256 "006f9c9126e2a2f4e7a874b5e1bd2abec1bbbb193c8b3b3a4c6ccd8c2d454bec"

  bottle do
    sha256 "42a97ee1056200cba159bfd23c90b5b3f81c9d51acead0de2191f2eadb758867" => :mojave
    sha256 "c333663d47d78e2d798f5c4781a9a03cb2d1ce12fede69e9e7d3480956b34e49" => :high_sierra
    sha256 "dd82c36ea4e2b80af822ecc84600906a95cf37ada8323fb13578bcfd2b81e2b7" => :sierra
    sha256 "52f314ba14ecae1761c57bf1fe6f261118de02f2c1075bbc6ad12ef31afb90d6" => :el_capitan
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

  depends_on "openssl"

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
