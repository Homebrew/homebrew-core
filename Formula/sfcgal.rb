class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.7.tar.gz"
  sha256 "30ea1af26cb2f572c628aae08dd1953d80a69d15e1cac225390904d91fce031b"

  bottle do
    sha256 "91ad496500abf1cac33f959e8008abe7724f642f8dabc28b455efec9948fd917" => :mojave
    sha256 "e07e7c3eaf40aaf29f288dc7be2bacc725f4376e8cb6c85fd7e1662ef001458f" => :high_sierra
    sha256 "9ae7e2ab05d3d8dd6331b68ebaf5714f2cf0f69f406029c8089e98d5aba4273b" => :sierra
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
