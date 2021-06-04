class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.10/SFCGAL-v1.3.10.tar.gz"
  sha256 "4e39b3b2adada6254a7bdba6d297bb28e1a9835a9f879b74f37e2dab70203232"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "23a7b9814562a30a7f87e9aa0bfc6a693d1e103acdf8e4879362e1beac292a99"
    sha256 big_sur:       "d3db5932f5c16c7612a3491fe635aede4c3fdba1dcf4fb46641e13a42bb8242d"
    sha256 catalina:      "12100fd5f5f69e3a4c3f2bb02190805a8189c3a37d86cf5c915e82dddc7bc239"
    sha256 mojave:        "125b86231c3f94ab06cb9d300366934d4d168d314c46355399ae9c6711ba9d95"
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
