class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.9/SFCGAL-v1.3.9.tar.gz"
  sha256 "2451cb6df24853c7e59173eec0068e3263ab625fcf61add4624f8bf8366ae4e3"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 "b2b7114676362a3731b59b55675c0f9cfed971596033933ebc55193ea8526716" => :big_sur
    sha256 "0293346eb037821d5ccc0b25b2f614d87b618ca337a8533a146add94968cb2c9" => :catalina
    sha256 "5b9747bc8fc4695cdf59252fde7d22dd00ba53bc2fee8092e4869326f643dce2" => :mojave
    sha256 "f8dd9ae70ab130d39d5526ad0c4df3803999dbf97cae044657d73fe9cbc320dd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # Build against boost >= 1.75
  # https://gitlab.com/Oslandia/SFCGAL/-/issues/238
  patch do
    url "https://gitlab.com/Oslandia/SFCGAL/-/commit/d07ed747e7f06acb22d5891ece789b331cff14c5.patch"
    sha256 "158b68643ff4de03aed064d1e494dd7e27acf86da3ae8949fddd78d5b73d6d73"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
