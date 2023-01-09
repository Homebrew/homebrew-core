class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b0b8527e194700363cc47e75a7b8d58c88798b0dc31671f5ae5c8803d8678fe6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ff2d81a1f04748053608401d726c198e92c9ad543dd644e47cb2046ed290a30d"
    sha256 cellar: :any, arm64_monterey: "c0444da5f21cf32b13bbdc10acb6d937c31085172373d98337b8d96850848b27"
    sha256 cellar: :any, arm64_big_sur:  "244e741e30e175250c1d655aa448c48a0081afee8e434ffd4138b279f28d4060"
    sha256 cellar: :any, ventura:        "04f04f6182f68da06e14439b60e08aba54ff2f6bf046afa5baa2b7d16e5a79d6"
    sha256 cellar: :any, monterey:       "8903b61a5edd7b424fdc961560e637146364fee525fe69002d43b70096cccf72"
    sha256 cellar: :any, big_sur:        "7071519fd285b6febff83f2f1298e9ee7cb28719efd0caae0e4a08f81aba9193"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on "libiconv"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
