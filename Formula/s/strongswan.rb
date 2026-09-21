class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.1.0.tar.bz2"
  sha256 "fe6c97481298767213cfc2e9a1da29fdd8018d481ff4cb9cf0283099654f20d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "3b1348d860baf46237f97e24726e8107350f3f0c5cbae68e36b6839502af6629"
    sha256 arm64_tahoe:       "2a9cce27fed8db4b83dd8181c1284e42c583788888c9aaeef9ec1a25b605c850"
    sha256 arm64_sequoia:     "8d1832026b25483bfd5735d7b262c7f9a69974fea9edc3628f6aecfafabe7dac"
    sha256 arm64_sonoma:      "ba11d900d659d376e9306aa9e1e81047a3b94c44f290d6a1f8d1be40bbf673e8"
    sha256 arm64_linux:       "0c80d564d7f0db7cae6bb6c588170a9b477fc1b7d03170c8b2cfb6efc29eff91"
    sha256 x86_64_linux:      "a56826d23e05553a4f7841f76efb1d0e30bbba3a0d11a026a4c9b328cc4e06a5"
  end

  head do
    url "https://github.com/strongswan/strongswan.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
      --enable-eap-peap
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
