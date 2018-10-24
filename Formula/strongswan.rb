class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.7.1.tar.bz2"
  sha256 "006f9c9126e2a2f4e7a874b5e1bd2abec1bbbb193c8b3b3a4c6ccd8c2d454bec"

  bottle do
    sha256 "1cbb4ac83e832978cce224ddde5e92e940484486fe22969166a10230193e32df" => :mojave
    sha256 "40cda2362e638287bf61ec0058c61c1b9d193c680aa0c8279ab6c86ef9da8114" => :high_sierra
    sha256 "4f829167204e004acb44aa813f5b0d7e2e6271d4cb91e6e0c580cefc1dddb8ab" => :sierra
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
