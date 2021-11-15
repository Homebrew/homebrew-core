class Svg2pdf < Formula
  desc "Renders SVG images to a PDF file (using Cairo)"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?svg2pdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b83f5a88a5b1e88ffcaf5c81186fbe2162e27d7b4fd93c60acd54c1d7897fb2d"
    sha256 cellar: :any, arm64_big_sur:  "dd41fd5b107ce28bbb2dae882cb0c86f7ba7a57005f0e826d492ffa68a760978"
    sha256 cellar: :any, monterey:       "9188bb1576693c48b47a326593d0a0ee1f14c1584ccc4c060c6ff042ef2fd191"
    sha256 cellar: :any, big_sur:        "358f4578b7a5fb09569411c4ac192314e2fa082aeb14cba604f2275ed888b72a"
    sha256 cellar: :any, catalina:       "7dff42459bf1ab33b0938f062d42c1857cb8274d1935f356b4f7dec76aac865c"
    sha256 cellar: :any, mojave:         "ba3e83fc0bf7a58166f2c4449b0f0d4590b5902ac2072ece48b9ca5eed13429a"
    sha256 cellar: :any, high_sierra:    "7a1c4ac8748a9c9013d6d6e50bd04b024e092dd718c878a0b7bcde3d9ca51a97"
    sha256 cellar: :any, sierra:         "bba8555de1a81fb92de544d77dc62fbe03e005b1b371d16127472890b7697503"
    sha256 cellar: :any, el_capitan:     "28e18b196650002c5c40c8cd6e38ecf26d16a5525f7d9ff9e2e3fe6dbfb9e17a"
    sha256 cellar: :any, yosemite:       "c8479dbc6d2eaea9a8fd6e5273d571e517cf260bd04468930aa24b185802bd8a"
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
