class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.strongswan.org/strongswan-5.9.8.tar.bz2"
    sha256 "d3303a43c0bd7b75a12b64855e8edcb53696f06190364f26d1533bde1f2e453c"

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
    sha256 arm64_ventura:  "e2ce9175afc09037bc4ed27faa94a8b67e39da94aa96c192b2f7d90d77b114b3"
    sha256 arm64_monterey: "e3bb47ea4d170a2d5fea7b474d95ec236651e631f470034c8d9ed58b8159416f"
    sha256 arm64_big_sur:  "8e88ec4ce51468217d447de72c72aa1ec4ab7ed3daeaf7d1231e192652933c90"
    sha256 ventura:        "cbf5e8a7c6032b867c63cae263da142e31cacf5eff314c90d6632970d8c7d9cd"
    sha256 monterey:       "b64777a6a4dd13eca9fc201c8da36e81c9a356be2ecae6ea37876da1b8f2a659"
    sha256 big_sur:        "126a9e7b798f5330db940fd6d361f4a563521d849af63924329b2a4cb237a823"
    sha256 catalina:       "5b8d29d581a539c5bc1bd40667c3584cf58c01eb2ddbbb6402e33512fafb4fde"
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
