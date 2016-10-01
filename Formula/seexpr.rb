class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "https://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/v2.11.tar.gz"
  sha256 "bf4a498f86aa3fc19aad3d7384de11d5df76f7f71587c9bd789f5e50f8090e1a"

  bottle do
    cellar :any
    sha256 "762881f740d763d3c2477f5ead9b2fc7c549f38721b39e999f9b6634f5215b68" => :sierra
    sha256 "0a374c2f84169d0b4ab064dfdd2dee856d5f80c9b8b27eee57e3d1614abffaa9" => :el_capitan
    sha256 "c023332d27c1977db807f890011688ed756eb130fa1df40aa562776192733ffd" => :yosemite
    sha256 "2e55d79f1519adbf0f1fdcf566aa67bd5515a60132516e2908250831d8e40355" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    system bin/"asciigraph"
  end
end
