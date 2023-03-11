class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://github.com/astromatic/sextractor"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.28.0.tar.gz"
  sha256 "36f5afcdfe74cbf1904038a4def0166c1e1dde883e0030b87280dfbdfcd81969"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "adefdbab76dff4d0f307293ad46531f52713c3dfb943e15044cbfc3ffcc3b497"
    sha256 arm64_monterey: "a331cf4bfc144696b3b36a5706e9abc806d498d3de393caeac651afb3ffba9e5"
    sha256 arm64_big_sur:  "84793b087afd51c196bbd1d7cc61ff1e2460342f599d190458fa158e80b5fbb2"
    sha256 ventura:        "84d024a112b1c47df638336b1fa91d337dac59bdc16e55f406725f3c391748bd"
    sha256 monterey:       "3fc5b83adaebe79b2dc230e8f27add68720c230e3728f046ef81e02fad08fbdc"
    sha256 big_sur:        "bea4796a93527c68fa743efb9b296ec6debed9224002b3383fe224276127f308"
    sha256 catalina:       "d8e1cce6c9238c4a99cfefde0548b818a62e1b0f0043a0546d6e7b06ae75ab5c"
    sha256 x86_64_linux:   "267543a12f47364ce29ffbb0cdfb28862aa6f98cc9412528b50115283706291a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "openblas"

  def install
    openblas = Formula["openblas"]
    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--enable-openblas",
           "--with-openblas-libdir=#{openblas.lib}",
           "--with-openblas-incdir=#{openblas.include}"
    system "make", "install"
    # Remove references to Homebrew shims
    rm Dir["tests/Makefile*"]
    pkgshare.install "tests"
  end

  test do
    cp_r Dir[pkgshare/"tests/*"], testpath
    system "#{bin}/sex", "galaxies.fits", "-WEIGHT_IMAGE", "galaxies.weight.fits", "-CATALOG_NAME", "galaxies.cat"
    assert_predicate testpath/"galaxies.cat", :exist?, "Failed to create galaxies.cat"
  end
end
