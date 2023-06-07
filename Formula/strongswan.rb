class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.strongswan.org/strongswan-5.9.10.tar.bz2"
    sha256 "3b72789e243c9fa6f0a01ccaf4f83766eba96a5e5b1e071d36e997572cf34654"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "a4d2de1acc7e1aa6caf1a05afd32754b54aa8b813d06d8ccd51297e51604125d"
    sha256 arm64_monterey: "2eae78bb4794a0a8f98474db0682df5a701ebfbeb7060630160949011c3f8ce9"
    sha256 arm64_big_sur:  "2c37898d4819ed9bd2eb3b738f5701b8c893361610e0b09e772901a3270ef8ca"
    sha256 ventura:        "a34c8e83cfa2d6f455fa0ac65426617def9eda97e62c059ca6244638b83f9f7a"
    sha256 monterey:       "f8f3d931112bced8b776907d95dd0d15b73d1e060eceedf02dcf7ca492ae8dc9"
    sha256 big_sur:        "66965a075e7b58ff0e031539182298dc4c1cf85072a7327b25031e0660d7d4ec"
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
