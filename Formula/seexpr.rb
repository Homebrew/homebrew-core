class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "https://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/v2.11.tar.gz"
  sha256 "bf4a498f86aa3fc19aad3d7384de11d5df76f7f71587c9bd789f5e50f8090e1a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ab581107fbb5bb7528c410fa80d6d6e82aab9c541a8223bc8cda99e7a4d5bfe2" => :catalina
    sha256 "5d169101ebae1861b26164770de46d5ae9ecf41282219b9d419a0a1cbb563b98" => :mojave
    sha256 "7547836d1b40c29fbfa118d3c25c6cdec2c9311c7ce7d1b254430196bc854c46" => :high_sierra
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
