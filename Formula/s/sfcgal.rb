class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.0.0/SFCGAL-v2.0.0.tar.gz"
  sha256 "11843953f49e7e4432c42fd27d54e1ff7ca55d0cc72507725c2a5d840c2c6535"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a5a7f00226cf8b89b1f5ff32b9fe9631cd6b9f4e5c327f623a772d41b9fb416"
    sha256 cellar: :any,                 arm64_sonoma:  "a12e862ef7496cb0bfdb492ec9949be9c50fa1a984c8b9f20dafef512f315fc4"
    sha256 cellar: :any,                 arm64_ventura: "315a037148929c830f9c288734944ccc74a0a8f688d43e5fc0ffaac7c54b26c3"
    sha256 cellar: :any,                 sonoma:        "8609c67b397d379b5f2beef2f34a9ec7ad92874f06f524a4b48698696f9f0d0f"
    sha256 cellar: :any,                 ventura:       "a0e4ed2664ff65b78076b2a00d1197a529e03719ee7265a5381eb20e6d564686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f87e1dfd50b1aa58838daa7246cfdce0dbe6304627b8a78b791758874fd3f32"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
