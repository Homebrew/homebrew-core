class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.6/tin-2.6.0.tar.xz"
  sha256 "efe19af0bd0e9656303dbc08902327082aeff4d281ae38a26f7df27e9f8fe009"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256 arm64_monterey: "d3cdf14e5bcd510b796437f0fdd8cca9efaede21cfb06883ae06e3805a85e16f"
    sha256 arm64_big_sur:  "dd6333436011c7afe7359aabbb6ce4d7eb63643e3140a0258be75d42d014243a"
    sha256 monterey:       "ccaa44f1cde97539fb3969d6946d7b7c3279ea9d4db02ec9cf7ffa4a2af1cff7"
    sha256 big_sur:        "57fb93692c45bab2f4b766c0aa5e5d8f55a1924e9a8944d48e903dcc67fcd262"
    sha256 catalina:       "017fcdb2227da2872b3d8a617ca9137b66d95a94acf57e09cca13f5e3c6c0035"
    sha256 mojave:         "ca4e1a52316a3bbb3f6d87b726e62043a307604501f4d3a30d1dc5909207a9e9"
  end

  depends_on "gettext"

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
