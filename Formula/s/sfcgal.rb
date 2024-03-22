class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v1.5.1/SFCGAL-v1.5.1.tar.gz"
  sha256 "ea5d1662fada7de715ad564dc810c3059024ed81ae393f5352489f706fdfa3b1"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e231f2da7b5607dcb1becb61d1a1ad325204a9237c1f3bb75e2957702bfcc1f"
    sha256 cellar: :any,                 arm64_ventura:  "0ebb2eb96864826e1c0746e88ff4c9eb201a2a8ea722a1a1efc0f003176b92de"
    sha256 cellar: :any,                 arm64_monterey: "78d3c2da9e4158cfa53b4d4afe9a502d5242915ebaa9159cc797b631185022d6"
    sha256 cellar: :any,                 sonoma:         "582092143e0f1ad9a2367e4834fcd69fbf080aec1de7686ffec9b004f95babc3"
    sha256 cellar: :any,                 ventura:        "aaba53cbe22214cafb54c712fbf57880148a4b78def27333a9197c4babf951f1"
    sha256 cellar: :any,                 monterey:       "3c97cb18901905c043e1c1f815f2c49f99303ba8d91acf9546fe267ca71fe467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19055419c3024400502c06a0d02880a8a670847413062a9533b2493c04f70309"
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
