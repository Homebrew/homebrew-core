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
    sha256 arm64_sequoia:  "2d31bce87c8288974edca4a5897ab7d73cdc174597138135e1774bfb5a24bec0"
    sha256 arm64_sonoma:   "5ba10147c3ecf0e90127558b0e71f9b5b5df75c6668d76f911b0aa549f935160"
    sha256 arm64_ventura:  "0fdb596affa3c1c1477487023a78f80ef5335cffa9bfd6301899c382f4c390c2"
    sha256 arm64_monterey: "f6d312b4f5d83e7717c01731dcecaac943579fee5f66e95f4b2afa022a0085eb"
    sha256 sonoma:         "52ce245c069d24c7eaa8102d2d89921e6a29da7da3bfdfd052cd582c014c5235"
    sha256 ventura:        "a6b6cd6c174a3e790a804e18c58b8c93f61b476b027d4a95b7fdc830aeba8d8a"
    sha256 monterey:       "85aaddadf5bee611b7cf791175810fd0ac203adfdb3471e8a3918605004f51e7"
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
