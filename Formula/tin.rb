class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.6/tin-2.6.1.tar.xz"
  sha256 "9da27203e9f9066a76bcb76e94ad67d4f2384a2e9aaccacf518e91d03b9f1853"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256 arm64_ventura:  "69d1e9fd22beea997f0fcf16d6f411c1ade3c099781ae2e4c3b14977b6b261d2"
    sha256 arm64_monterey: "3da6ca54a9306da6d17e1c6248c37081ef3930a0d1f116990a50a091f1565d37"
    sha256 arm64_big_sur:  "de118ef2c4532cfa71dc80c1e2205074818e0ba57c48bc9f2e63487caf8e26f6"
    sha256 ventura:        "5a5cdbb6b8ccf500059f9891eaf9ff779b36e8700d568bde8e014faaa7972961"
    sha256 monterey:       "8897ee5f24a4004476bc93f15960c7f66d678e3f1e1636cbd8ab4c062c36053b"
    sha256 big_sur:        "12a0c54fd7adf50bf9e495045bf63deb70c640d9a93614fd36679821d4ad4343"
    sha256 catalina:       "5da812d0f63586b3e8f29b87d13eb143833d807034acef91eab05802700aa394"
    sha256 x86_64_linux:   "c406776b10d1477ace215d59459332fff266f4b768c7c9d6d2837b1f550a57d4"
  end

  depends_on "gettext"

  uses_from_macos "bison" => :build

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
