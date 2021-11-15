class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "https://viennacl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.1.tar.gz"
  sha256 "a596b77972ad3d2bab9d4e63200b171cd0e709fb3f0ceabcaf3668c87d3a238b"
  head "https://github.com/viennacl/viennacl-dev.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a95ad5ebf44a0b14c98a7b464ca6a3f83c47b8b9d6609b508051faf1ce3a41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a59335b82a9f92448236ec0278d156f2425995d48fddcef730b906ca63aea6f9"
    sha256 cellar: :any_skip_relocation, monterey:       "c15b7b7033a93664765ef18222701e12adc7f0ef3ca797891aee90e826d87a96"
    sha256 cellar: :any_skip_relocation, big_sur:        "696235e232844f8af5d062bc9197ab87fcacb012da49304b7cce059b145255cf"
    sha256 cellar: :any_skip_relocation, catalina:       "6fa1cf4450123da7e4af2910f6a9c41e7005d5591e05d035c06adddff44f25e0"
    sha256 cellar: :any_skip_relocation, mojave:         "0d2ae6a32779520d35e8194948a0df499bc147743fd54f59fe3c69e833e84f1c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7be4bc5f161868a9646a575530acd83034e7af6e39439e262c499b219738e74e"
    sha256 cellar: :any_skip_relocation, sierra:         "809b0ff014ad6fdae2337ac8dd0cde29c72fe4cb8817a7e7417e9722b7572059"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cb5cd96fd4c730518b6b0e150fd15386ad71576e444bfbbd5f055e844d4a5976"
    sha256 cellar: :any_skip_relocation, yosemite:       "875f61b8270246247450c0beedc9710b52d07171717dd2f9de9a493f3b4027b6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    libexec.install "#{buildpath}/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system "#{opt_libexec}/test"
  end
end
