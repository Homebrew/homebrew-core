class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2020-src-8.0.0.tgz"
  version "2020.1"
  sha256 "1ac92a5538f61e297c72aebe4d4ffd731ceb3e6045d6d15faf1c212713798df4"
  head "https://github.com/qhull/qhull.git"

  bottle do
    cellar :any
    sha256 "2914810492c9ef6f46606237d8ab3adc84b4cdb5edfdab722dfa4adf58864504" => :catalina
    sha256 "fcee31c1350555f924e27fc7868c4244fe9e6f3be67dc9a91426c85f27e65306" => :mojave
    sha256 "9eab455f07e6bc666960235f23919cce155bf630a689cafdf346083dc88925df" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    input = shell_output(bin/"rbox c D2")
    output = pipe_output("#{bin}/qconvex s n 2>&1", input, 0)
    assert_match "Number of facets: 4", output
  end
end
