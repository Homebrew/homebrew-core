class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.6.tar.gz"
  sha256 "5840192eb4a1a4e500f65eedfebacd4bc4b9192c696ea51d719732dc2c75530a"

  bottle do
    sha256 "991c98fba3828ffab869051ee2dadcfc909f10c49fb3fa26a6df902a161c75b6" => :mojave
    sha256 "041efe2007327376ab0541aa65bcd43c3d34c0a81f0d7bfef6e981925b0a8ef7" => :high_sierra
    sha256 "2c41d34e6d241e2c1c4d0de5e08d793ce5c4a22aa5a93b1c258f62d2e0c2c940" => :sierra
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
