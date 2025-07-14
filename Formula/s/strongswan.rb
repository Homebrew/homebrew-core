class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.2.tar.bz2"
  sha256 "b8bfc897b84001fd810a281918d6c9ce37503cae0f41b39c43d4aba0201277cf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ccecd25f08f24fd32178ccdc58f98ba3cb43e5f8145786fca72f02b5efaa7242"
    sha256 arm64_sonoma:  "1fa01b0d9382a6af24ff0220dccdd83a3a56c87c37b0d7c48487c4c7f1b4d4cb"
    sha256 arm64_ventura: "ad54d4161628511ebb7ea92ba2ce4d6da9a5ad4048949110a988658019c11c9b"
    sha256 sonoma:        "28c6a9c784715f75817a784726bf8aeadc734c8c3e7b6728ac79ad8c01c7e840"
    sha256 ventura:       "6f23fcd4ef43c6262bdf09821aef9c44a7bc5d2c7db4a7e6b2c9f8d95f0e4690"
    sha256 arm64_linux:   "baf7a4be65bb2ef39608c0d27a9aef2469e0d4180f6cea72584306ec4e860da8"
    sha256 x86_64_linux:  "eb4968f284518e118309d8ca96af2e858c2976165b1e9a8fb924f3f7268b2cb7"
  end

  head do
    url "https://github.com/strongswan/strongswan.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    # Work around RPATH modifications corrupting binary. Upstream patchelf fixed this issue
    # https://github.com/NixOS/patchelf/issues/315 but it may be missing in patchelf.rb
    ENV.append_path "HOMEBREW_RPATH_PATHS", libexec if OS.linux?

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
      --enable-kdf
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
