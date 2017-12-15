class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.2.tar.gz"
  sha256 "1ae0ce1c38c728b5c98adcf490135b32ab646cf5c023653fb5394f43a34f808a"

  bottle do
    sha256 "f768925d0f01d8c8ea0c131a886d9ffb10677d90e86591f6d3a71adfc136975e" => :high_sierra
    sha256 "ab1b173aa969908975b426e0e1b6e743c18f3e9da19007b0b7e1833b92969bd7" => :sierra
    sha256 "0348fd098cfb8a0d2ce913fa256178c63c47216415507a962c5999a5c62853ac" => :el_capitan
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
