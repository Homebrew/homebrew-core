class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.5.3.tar.bz2"
  sha256 "c5ea54b199174708de11af9b8f4ecf28b5b0743d4bc0e380e741f25b28c0f8d4"
  revision 1

  bottle do
    sha256 "1f94fb9fbd97fb9d85203f23c14127c641f9652bd996d78d8893739fb14a6df7" => :sierra
    sha256 "6359e18261363a78886415c0d8bc35ac765ab5413af579aaffa093ec6736e2d1" => :el_capitan
    sha256 "6a168da2a39dc1e109d5bd5f12e413dda8ec3db017aecc5793cfa1b23b169097" => :yosemite
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
