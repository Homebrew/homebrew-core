class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.5.0.tar.gz"
  sha256 "1fc0a480982caef9e7b9423070b47750ba34cd0ba82668f2e638fab1d07adae1"

  bottle do
    cellar :any
    sha256 "9800e87eaeeca3eca0d59c3bca555c0211df96f021735251964981ac2b16bd90" => :catalina
    sha256 "90f9b9b0ccadf93be027e515be356d0b92f4dfb33979f11df9fc7570c3249d0e" => :mojave
    sha256 "f1242aaf566b272f69331d16441171b12d0b4cef8396b56e0a8246fe7618ca68" => :high_sierra
    sha256 "0add799fff38395de6300f1b18102270bd269b5dc37714e7cac1873849b2ced7" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end
