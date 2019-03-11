class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.6.tar.gz"
  sha256 "5840192eb4a1a4e500f65eedfebacd4bc4b9192c696ea51d719732dc2c75530a"

  bottle do
    sha256 "a93d0c08573d27ec212da50cbdc64bdfed404808f8cbe0a300719c10fec07618" => :mojave
    sha256 "485b8f11ac8d17d8f82d39e1ece3cadf48c05dd8e0090cafcb30aaff93341a43" => :high_sierra
    sha256 "76e96ef51af1b0d4f7dc3ef37d8a2a6032ec12c24d5743445c48a4a280d962c0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
