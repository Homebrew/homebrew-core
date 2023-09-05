class Qstat < Formula
  desc "Query Quake servers from the command-line"
  homepage "https://github.com/Unity-Technologies/qstat"
  url "https://github.com/Unity-Technologies/qstat/archive/v2.17.tar.gz"
  sha256 "ff0a050e867ad1d6fdf6b5d707e2fc7aea2826b8a382321220b390c621fb1562"
  license "Artistic-2.0"

  bottle do
    sha256                               arm64_ventura:  "11a9a33fc7615e85441444af37ed41d87f0659f672d958824f7cca77eacd2729"
    sha256                               arm64_monterey: "407570a7c868ec0815588e1b2c5ed8716b1392bc7452fcc31ab1b16f217febaf"
    sha256                               arm64_big_sur:  "381072b9472ed1ab8a8f0d7409571262555d33da9d02f3ccdabc117bc9d6a6c5"
    sha256                               ventura:        "288eff7f500462b9adcc7e3704fdd2b07ce5853830adfa9d246aa67ff1411df3"
    sha256                               monterey:       "1e7728d7b8689eec71c2285e3c1595180a985f6d44d32d6452df62da33ab4bab"
    sha256                               big_sur:        "e7620697e587b4e46f1f0a1558e2fb9a1dee96c289958ea54269cf7321197d26"
    sha256                               catalina:       "c8308182a8669cd883eca05230d449aaeb0026bb47bd4b1a2d420a34b6051549"
    sha256                               mojave:         "8673b95f024ded9f7e2c7a721a7672b9f36f9258c25dfffa7b83a0b742e308b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed20930d202d32949a50b610cf9897ee8d33e3fcea72de224ef1815827c55e70"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoupdate" unless OS.mac?
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qstat", "--help"
  end
end
