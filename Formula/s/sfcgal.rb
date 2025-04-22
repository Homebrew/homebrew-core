class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.0.0/SFCGAL-v2.0.0.tar.gz"
  sha256 "11843953f49e7e4432c42fd27d54e1ff7ca55d0cc72507725c2a5d840c2c6535"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80d4522710c8eb197f01e3d3f87dd850180007211f806e681ba6686624bd2f38"
    sha256 cellar: :any,                 arm64_sonoma:  "64a1390eba8851948fcb377e95cc358f9411001c6ea1c9db6d83df8ddab90b22"
    sha256 cellar: :any,                 arm64_ventura: "0b508c43373ae8110453a0deb0ba9b7e8e12f63201ba3c73ce770cc74d10195e"
    sha256 cellar: :any,                 sonoma:        "45f58305ff1c4dfd97073088ede8eba3f09eff50c3d4131bdceba3de5863ee16"
    sha256 cellar: :any,                 ventura:       "b0a9afee6f483df2da88e2f51c262d2099af8cd83a27dc45d83101d2f27f9ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb76f0a64fead5296106c2eedd97acbe4c06dea5ffd4c7f50c03150ba248993d"
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
