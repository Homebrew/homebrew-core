class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.9/SFCGAL-v1.3.9.tar.gz"
  sha256 "2451cb6df24853c7e59173eec0068e3263ab625fcf61add4624f8bf8366ae4e3"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 "a84e1882800689fe3312cf3b93f179a5e34539151ef558468976003ae97d2692" => :big_sur
    sha256 "ccef404f840195d1f22cc5915ce243009cd15f7d488419f6092afca25a1ac549" => :arm64_big_sur
    sha256 "059645e8217cd404f6ae60c7fc3c9dcc98c6b0d64aa1756cf5ee2ebbe6d5c509" => :catalina
    sha256 "8180bd969a152778f3eedd4149c517ea88d5f22efe1955d418e551808a405992" => :mojave
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
