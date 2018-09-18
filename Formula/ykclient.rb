class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://developers.yubico.com/yubico-c-client/"
  url "https://developers.yubico.com/yubico-c-client/Releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    rebuild 2
    sha256 "73b153bb1d9f5df3aa3a4ffed206c60bd1f207946b9cb43116985ed0cf76de8e" => :mojave
    sha256 "3e1459f192f7f1df756e2071c78ee41fd163b3dee1f09254e8e5ffc0442a2205" => :high_sierra
    sha256 "aec1bc9640c8a84089b1d749d689b59862fce858478d180cd6a34a93a34eb370" => :sierra
    sha256 "deee73fbd68f44bd86fb07d1f2179313dac4679395d861b821ccf218745ab1c8" => :el_capitan
  end

  head do
    url "https://github.com/Yubico/yubico-c-client.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ykclient --version").chomp
  end
end
