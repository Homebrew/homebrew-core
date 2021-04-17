class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.10/SFCGAL-v1.3.10.tar.gz"
  sha256 "4e39b3b2adada6254a7bdba6d297bb28e1a9835a9f879b74f37e2dab70203232"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ccef404f840195d1f22cc5915ce243009cd15f7d488419f6092afca25a1ac549"
    sha256 big_sur:       "a84e1882800689fe3312cf3b93f179a5e34539151ef558468976003ae97d2692"
    sha256 catalina:      "059645e8217cd404f6ae60c7fc3c9dcc98c6b0d64aa1756cf5ee2ebbe6d5c509"
    sha256 mojave:        "8180bd969a152778f3eedd4149c517ea88d5f22efe1955d418e551808a405992"
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
