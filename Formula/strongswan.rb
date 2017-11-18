class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.6.1.tar.bz2"
  sha256 "e0c282d8ad418609c5dfb5e8efa01b28b95ef3678070ed47bf2a229f55f4ab53"

  bottle do
    sha256 "c6241f48a9eac3d3f77ebaf44057a8a4fe37cc1592340e8bde2577c1ad894b16" => :high_sierra
    sha256 "61461a200f859adc1f2130151b14ea2f960ba9f7c042b74027888508a72ed762" => :sierra
    sha256 "ef21438d02abb2571c4e0a5f974e7b65220e63a8c5a37e743a09482e3877624a" => :el_capitan
    sha256 "1359184d5e990d3bad261037ba409d7ee5944971bdf771bef14ddb1be3fb7bf2" => :yosemite
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
    msg = <<~EOS
      strongSwan's configuration files are placed in:
        #{etc}

      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
    if build.with? "suite-b"
      msg += <<~EOS

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
