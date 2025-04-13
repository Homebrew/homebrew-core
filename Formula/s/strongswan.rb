class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.1.tar.bz2"
  sha256 "212368cbc674fed31f3292210303fff06da8b90acad2d1387375ed855e6879c4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1d400a27f9827ddc6cf1558f1745ec2de5b726b5846fc0ccb940ce1ae4816c46"
    sha256 arm64_sonoma:  "a53259dbcb6295c222daf978857a3bbc5b9227d008c77a211f92ad7341ab72ca"
    sha256 arm64_ventura: "fa99e2acc5b7dad59ba0c34729ac9962265b3a44471b76ea2ccb3449b091a6d0"
    sha256 sonoma:        "324b1831262b1913c26de58b0062943a9d453fac4ed1b1ebc8448b47457e207f"
    sha256 ventura:       "328816ca28f4d263fc8389a4384b481c86f46a2e1d43f152ba7a1ab6ca10b656"
    sha256 arm64_linux:   "5933ebc1945502e575568a71fd8f230164aafad1228b0fc41e895c848a25113a"
    sha256 x86_64_linux:  "5639fc4928b7bf717c6c4eb52db38c58205b332c9a3694f8197195555e24a165"
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
