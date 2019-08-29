class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.8.0.tar.bz2"
  sha256 "15b1e10c7dd6253ab5d791fe9b9cb84624e24c118aecd9b90251b4e60daa0933"
  revision 1

  bottle do
    sha256 "b7ecdc25dcb364981e83f6aed2d115f054d61321ebe6c7c61754456fe0744302" => :mojave
    sha256 "bf050912991b312ff534cb38a5507a69154c76bb1a4c959dbaeb3d11f8d1a5eb" => :high_sierra
    sha256 "4614d547317a13c48a9cfccd0a8ff4aa097c6122ae5262e21f91d9e4b934d7d1" => :sierra
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
