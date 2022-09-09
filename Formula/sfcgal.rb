class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f833b030cc55538c801f0b569c36f9b7b5303de882a5f46c8478a4b27550fd9c"
    sha256 cellar: :any,                 arm64_big_sur:  "04ff2155b259479a1f3e3b31fcb6881062ea29c18e955279f525bca5b4509b7d"
    sha256 cellar: :any,                 monterey:       "14083513643fe64312a098842a3fc3e8c8f9ee3fb923307e73792d14d634d66b"
    sha256 cellar: :any,                 big_sur:        "0c96f4ff9ef0df19ed37ea0845e2d2ee212aefb880027595fe5d678c4a384fe5"
    sha256 cellar: :any,                 catalina:       "79611e06698fc3e7ffcebba3f228f66937eb66420e75514d1d72274b580f4b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb92b0564f3f78f081ad9880e68a9dae1e2963ff5884f9039dddaa9145a3e4d"
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
