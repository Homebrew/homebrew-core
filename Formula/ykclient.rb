class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://developers.yubico.com/yubico-c-client/"
  url "https://developers.yubico.com/yubico-c-client/Releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dae78aa836f872c6e8767c2e8ea2c295a16161329ea4fa3b27a1dd1d31b66153" => :sierra
    sha256 "1175f6f20146f23d7e650147ce0fc0963d71b3efb294402c649e05a29def3f41" => :el_capitan
    sha256 "fb7c3d237a80f3c5f3c8274c014bdd00318cff4aba499a7936f11c857c5d2e14" => :yosemite
    sha256 "96ee6e8f265432b340e3b1512b2ce102dbd64a948c37a53779cded0bb92ac5cf" => :mavericks
  end

  head do
    url "https://github.com/Yubico/yubico-c-client.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ykclient --version").chomp
  end
end
