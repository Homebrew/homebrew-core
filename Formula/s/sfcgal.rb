class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v1.5.2/SFCGAL-v1.5.2.tar.gz"
  sha256 "b946b3c20d53f6e2703046085f0fcfea6c1a4081163f7bedd30b1195801efdd2"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a6c5e58c97b9cc94d3900e7bb23c9804169f1d266a34f77a978a6d4ca84fdf31"
    sha256 cellar: :any,                 arm64_sonoma:   "a2b1a9cac32d00ecf18cb0a7d9d88ed889ae1c82177042893ee1cc0b151971d6"
    sha256 cellar: :any,                 arm64_ventura:  "3143d8fcaa298e88ef25967d3023a38788736677278a6b4f0e0503b9e99e9afc"
    sha256 cellar: :any,                 arm64_monterey: "87555736150d79ed8a8840e4c7bee8bccb3b02964bb876707e88ed063dd21621"
    sha256 cellar: :any,                 sonoma:         "ed8cd80f0a7b6052ef7bbc6c3d063b8ae0e823885b635b2276b12b82aa3d2e86"
    sha256 cellar: :any,                 ventura:        "c2ec6da16f95a8de586fc6ee9038f06407afcc4ec70feedb92d89ef7c9bf6545"
    sha256 cellar: :any,                 monterey:       "abf15d5e04078f3b49e8dc25dfa09de808ab08fe5f630bc1f0efb43d9a65d535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8e65d7e83c0426427154292e266e8f771213c2b38d2ef9e02ddce37886ce84"
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
