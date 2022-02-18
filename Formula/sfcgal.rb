class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1e98264a7df119a546c5ab80bcd017ee9cabe50299bc55543a20735427fe2d4b"
    sha256 cellar: :any,                 arm64_big_sur:  "a0e9c2ba3a9887f8b7fcf6b0e4604a2c2d806519d4ffa3c50918d2b8eb1c12ab"
    sha256 cellar: :any,                 monterey:       "bba4e08da94c953fe43557508cf3bc9a6af42bf7d550541cd6c295a49d9ed6c4"
    sha256 cellar: :any,                 big_sur:        "12c0ff36264354e9d59d3ed910e3c40843938892397b9d9ee8930166b5334bb9"
    sha256 cellar: :any,                 catalina:       "f2342ad06c38171b85bed939520c49f70228fcf811478ac86a0f8f8f693ef874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7f415f696b65fa7d5151edaf146655c74b8a27cded760a26b7d001dee88892"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "gcc"
  end

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
