class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2fe4702eb22021be4e88cdf4a2b0de7ef63354838d3efbbf932d2421fe574462"
    sha256 cellar: :any,                 arm64_monterey: "ce56024a7fe7128cc0c46d38c9d0ebc7b884ca45b515e53c855e50082c8bf78c"
    sha256 cellar: :any,                 arm64_big_sur:  "a277214793c453cfe4238c0c764f64e1cec3a3ebd9b67185a452289717ea5f7a"
    sha256 cellar: :any,                 ventura:        "98227ad7c6790297273b0908ac90ff3fc545daa29dd7651c25b1535628f41dc3"
    sha256 cellar: :any,                 monterey:       "2b3e3d6bc3c0b3f0a1e4d60c006150ffaabb8ce94320334c2c098de90e838a9e"
    sha256 cellar: :any,                 big_sur:        "afb6e18acaa58068cee76d2a0034c8a21e12dc6f1bda5ff35a2338e2a02befa0"
    sha256 cellar: :any,                 catalina:       "e2a48b73d1fc26ec367a863199ff145c6258edadb1c9e2d63c90d64a27721f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8839f174f0bcb73c6e608bb0f2473c6b9c1bdeac6db8769fd9bb02a02159c49c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # error: array must be initialized with a brace-enclosed initializer
  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
