class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.6.tar.gz"
  sha256 "5840192eb4a1a4e500f65eedfebacd4bc4b9192c696ea51d719732dc2c75530a"
  revision 1

  bottle do
    sha256 "1233cb0320a8d0733f75304b4ad4d35f666c6e4fb82a720bf235d9bb58ddc75d" => :mojave
    sha256 "04ae604dba05457c2494c38f7ad9120ef001dd0d87cb6247a9d4cd2dca442096" => :high_sierra
    sha256 "02723bd904ea2bce6a7b930d87755ac4cc5893ecf72045b51f9d27aba00ebfaa" => :sierra
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
