class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecc07da7084fd82a31bb7f559078f0c33e3ae555a1d75b9ef4c4630442db7bf8"
    sha256 cellar: :any,                 arm64_big_sur:  "f7011cca82cb20daa201c9a651b09e6648c1bf0b21388d3b45a4d93832e88386"
    sha256 cellar: :any,                 monterey:       "0949359cfb9e3b10cb4e1b8287e2221e2b4aa473bd85f885a2400d56ac80b5e0"
    sha256 cellar: :any,                 big_sur:        "744d2cc9163d8c828b97802b9f936e224a2094766ecea4a28dce3a22f5688008"
    sha256 cellar: :any,                 catalina:       "6149c424f58cc50e2538ccfaed3e2aa664b06c720a05659bffa5e7833e69941d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b5af527fb033f3c79ba7e47d5718cac20c89e83109aa35b452f5db7ded3d3a"
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
