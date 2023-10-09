class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bc6c995493f0ce8530cbc1c2109a9c63affc862c4f4963406fe7024c2c30d85"
    sha256 cellar: :any,                 arm64_ventura:  "d2986bd33428614aed8fd61d52e81331003178532ac7749914429786432b1b75"
    sha256 cellar: :any,                 arm64_monterey: "679e76ea188a7c9aa039dcb762b7ca8375e35009f4b1ac49dd787100ef3705f0"
    sha256 cellar: :any,                 arm64_big_sur:  "b10a871b2372aeb03c36b2fe9d2b7d45518b2b4ad0d27b5a10e3a133632c6acb"
    sha256 cellar: :any,                 sonoma:         "9741cc0132a0fc5cca2d471b8a968bdc7a07e03140521d881fc784f97bf8e7e7"
    sha256 cellar: :any,                 ventura:        "bf5a5e7d0a59f52e41dd2c6e5137f8ce684fa7b44f1d5dd803ad9a59f3050d76"
    sha256 cellar: :any,                 monterey:       "bca215c4596244f5de554e14d68774950e8ca9d7f5f0aa1d66da5ef0ee960da8"
    sha256 cellar: :any,                 big_sur:        "aee4b0a1b0ce8ac96413f603ced79d4139476938eda9ca5caffbce8bd0f90935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ab272a0db9c4e22fa4df1df5d8e78bcf72ea02923b485babfd843b97e8002b"
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
