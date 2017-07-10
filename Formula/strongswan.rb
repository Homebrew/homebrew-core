class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.5.3.tar.bz2"
  sha256 "c5ea54b199174708de11af9b8f4ecf28b5b0743d4bc0e380e741f25b28c0f8d4"
  revision 1

  bottle do
    sha256 "f7bb70f605b43ee8ba2f5c69d8ac12f3fb5482d065e809f1d4e41b190a2f3961" => :sierra
    sha256 "66493584f56c0a4434c96b9694e73fbd65c6cceb75c43a990bab8ba8115dc6fb" => :el_capitan
    sha256 "6cf78eb774355dd7e0ddd5b7025619a09296f62415201c5bfd6e02c5aca10999" => :yosemite
  end

  head do
    url "https://git.strongswan.org/strongswan.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "gettext" => :build
    depends_on "bison" => :build
  end

  option "with-curl", "Build with libcurl based fetcher"
  option "with-suite-b", "Build with Suite B support (does not use the IPsec implementation provided by the kernel)"

  depends_on "openssl"
  depends_on "curl" => :optional

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
    args << "--enable-curl" if build.with? "curl"

    if build.with? "suite-b"
      args << "--enable-kernel-libipsec"
    else
      args << "--enable-kernel-pfkey"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  def caveats
    msg = <<-EOS.undent
      strongSwan's configuration files are placed in:
        #{etc}

      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
    if build.with? "suite-b"
      msg += <<-EOS.undent

        If you previously ran strongSwan without Suite B support it might be
        required to execute "sudo sysctl -w net.inet.ipsec.esp_port=0" in order
        to receive packets.
      EOS
    end
    msg
  end

  test do
    system "#{bin}/ipsec", "--version"
    system "#{bin}/charon-cmd", "--version"
  end
end
