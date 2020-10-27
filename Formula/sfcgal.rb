class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.9/SFCGAL-v1.3.9.tar.gz"
  sha256 "2451cb6df24853c7e59173eec0068e3263ab625fcf61add4624f8bf8366ae4e3"
  license "LGPL-2.0+"
  revision 1

  bottle do
    sha256 "0293346eb037821d5ccc0b25b2f614d87b618ca337a8533a146add94968cb2c9" => :catalina
    sha256 "5b9747bc8fc4695cdf59252fde7d22dd00ba53bc2fee8092e4869326f643dce2" => :mojave
    sha256 "f8dd9ae70ab130d39d5526ad0c4df3803999dbf97cae044657d73fe9cbc320dd" => :high_sierra
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
