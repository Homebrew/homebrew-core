class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.2.tar.bz2"
  sha256 "b8bfc897b84001fd810a281918d6c9ce37503cae0f41b39c43d4aba0201277cf"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9b7f3f2b29597a88c53bd2bf67e512010e4a8be456174ef4a448dedd76ad44d"
    sha256 arm64_sequoia: "f979b19cb45dfa5e0edcc2378f4de546db207c0e274f4cc6b35ab0717d8be705"
    sha256 arm64_sonoma:  "020a609cc20abd5cbaaef1176a2b6847063d9ec214bf27dcda1cf9dc69242fbc"
    sha256 arm64_ventura: "aebdb402d0eabc341bca2687a16c5f485d3bedc61960d03bc45d23c8c171f1b1"
    sha256 sonoma:        "591067d4f91dfb873a24bb705b0f338a7dca02205f9b7af66160d0d2a2492b50"
    sha256 ventura:       "c3dd4eedb228092e96f4dee85758cd7d226a61a903e3e947c12301ea1e395d1e"
    sha256 arm64_linux:   "e7236b73db35f0c1c009e0232287d81ac868e8a69cfe6c891b8b8034b091de9b"
    sha256 x86_64_linux:  "f908cff26d8cd820122aefb580bab3bc93b36744341ed583dd2ec6e07787047b"
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
