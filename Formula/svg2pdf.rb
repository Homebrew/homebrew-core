class Svg2pdf < Formula
  desc "Renders SVG images to a PDF file (using Cairo)"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"
  revision 1

  bottle do
    cellar :any
    sha256 "ba3e83fc0bf7a58166f2c4449b0f0d4590b5902ac2072ece48b9ca5eed13429a" => :mojave
    sha256 "7a1c4ac8748a9c9013d6d6e50bd04b024e092dd718c878a0b7bcde3d9ca51a97" => :high_sierra
    sha256 "bba8555de1a81fb92de544d77dc62fbe03e005b1b371d16127472890b7697503" => :sierra
    sha256 "28e18b196650002c5c40c8cd6e38ecf26d16a5525f7d9ff9e2e3fe6dbfb9e17a" => :el_capitan
    sha256 "c8479dbc6d2eaea9a8fd6e5273d571e517cf260bd04468930aa24b185802bd8a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  resource("svg.svg") do
    url "https://raw.githubusercontent.com/mathiasbynens/small/master/svg.svg"
    sha256 "900fbe934249ad120004bd24adf66aad8817d89586273c0cc50e187bddebb601"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    resource("svg.svg").stage do
      system "#{bin}/svg2pdf", "svg.svg", "test.pdf"
      assert_predicate Pathname.pwd/"test.pdf", :exist?
    end
  end
end
