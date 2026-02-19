class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.4.tar.bz2"
  sha256 "79576bb61b9a406cea9eb73d0c565cc6254a6b6d2e7198f44758d2d7c61a7aec"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4afdb48f27554ca9edfb94c87a109c9db7d23c6ce160851b53b9531aecbc0a5f"
    sha256 arm64_sequoia: "c54f449c7289620209ed62f917144ad8d8b073452560ec95af9f057f3ee00dd2"
    sha256 arm64_sonoma:  "a1e39050985cbb78a40045e70872e5904ede5ea81c2f750d6dd1919da651a5bc"
    sha256 sonoma:        "ce0ca37b4cbc08c2299328c0bc623d44c5edd5c80a08c9e719aaa446627e9f39"
    sha256 arm64_linux:   "8d7cf060f8f44f7d5bfbb0687c924c72ba2fd49630f1ffa8320d06c35e732e03"
    sha256 x86_64_linux:  "58d4bd1f14b474d61e665a6a34cf9b2a1ad14a1803c59baf5078fe78843a2be7"
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
