class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.9.14.tar.bz2"
  sha256 "728027ddda4cb34c67c4cec97d3ddb8c274edfbabdaeecf7e74693b54fc33678"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "b60dab9422792d21de64de8f5ab42203f71bb1620edfd7801c2110ca7b0672a4"
    sha256 arm64_ventura:  "0a1fa8983cd37750912fa4d76e55a6dcc1693f15df8c9144032321dab0c37f9b"
    sha256 arm64_monterey: "8dd5ed7854c469a27efd3e6a4849a3b4b6d30c725554a0329196de93b22b84d4"
    sha256 sonoma:         "b7119f1f155237b204bddc13bbf951eece16becca11f675f5a977d1395945c51"
    sha256 ventura:        "732978bdf6f719e5750d4f9177750d760dd0bc617beff421bbdfda02d9909b42"
    sha256 monterey:       "7344b1d75d5eba6e015d66158e03014f49034b52b1390a37fd8a7048e4358dd4"
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

  uses_from_macos "curl"

  def install
    args = %W[
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
      --enable-curl
    ]

    args << "--enable-kernel-pfroute" << "--enable-osx-attr" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsec --version")
    assert_match version.to_s, shell_output("#{bin}/charon-cmd --version")
  end
end
