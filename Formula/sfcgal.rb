class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e5830b19bfb9193625b1cc8149d2f678b873134b9edfcdffcc73b5545a6d04b"
    sha256 cellar: :any,                 arm64_big_sur:  "24af7d6e9dae322da56ec1cb51c429b972a41e6a297956f6baf607e3fa6af836"
    sha256 cellar: :any,                 monterey:       "3c83e7b2aed9400f9d48c7e43e1ed2f095eba9fda57628c1101ef43e1b670a86"
    sha256 cellar: :any,                 big_sur:        "0066a1386a0b985a98b7e06f42d7aa43d227d4e9bc234aff3a6b36056ea956e2"
    sha256 cellar: :any,                 catalina:       "39dd3c723b7d47a807f1fffa6c1de053d7091ac15e2180341588c2c94ff247f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd13dbab941fee7f795c1fc7ae62299158c2325df7d1d83c8858b14985677de"
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
