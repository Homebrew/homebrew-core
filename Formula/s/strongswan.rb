class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.3.tar.bz2"
  sha256 "288f2111f5c9f6ec85fc08fa835bf39232f5c4044969bb4de7b4335163b1efa9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c441d10a008ffd0d973f4845067c59d9222b219694e68668795540a9e30921dd"
    sha256 arm64_sequoia: "be3628964984571bda1fb570304a7f2330967dfd03a3d72b71cff239f409f7cd"
    sha256 arm64_sonoma:  "e9f428124bd397b8467a3801c1b3e7c10a6448994507504e3663e3846af15d83"
    sha256 sonoma:        "8c0d56d754161ac24c4c28b8f426c557d387744c9c2d5c349116e901a7c15822"
    sha256 arm64_linux:   "603db325f5b28d8f3d4c91ff1cde5ab552f16008a0396596817147904d17c6da"
    sha256 x86_64_linux:  "21cf828aeb4fc58dc7d65f793a8af0f8d6376c0dbb185e9007d760026960d3b5"
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
