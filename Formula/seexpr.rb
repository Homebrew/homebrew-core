class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "http://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/v2.11.tar.gz"
  sha256 "bf4a498f86aa3fc19aad3d7384de11d5df76f7f71587c9bd789f5e50f8090e1a"

  bottle do
    cellar :any
    sha256 "a0ab2f6f50d81504f2767c03daf3d99fd9fd433b67a507a7d367b0970f0e01f3" => :el_capitan
    sha256 "f26765862bfbd77b50fe6613f70cd26db486992615980efbef2a808f0e8a99d3" => :yosemite
    sha256 "000ddf09be887ce59a805445078b4dd91712b1e6a81bf33d543771eff1298134" => :mavericks
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
