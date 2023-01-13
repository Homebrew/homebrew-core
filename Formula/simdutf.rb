class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "b15a81cc55d548ff69d57286ce6e7fdeb9ea1c0870ef8c5e85ae7aa791f92324"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "819dedd5f5791e7a02876c055d8f90ab9fd9d8d66e1d90ffa5b5d58eef727030"
    sha256 cellar: :any, arm64_monterey: "559beddbd9af1f2523e74a53332627fca9e421190f80dabb1c6830640810109f"
    sha256 cellar: :any, arm64_big_sur:  "6c13f3ebccb49fd31b4d5d22d9b28ab9a25433b470e250eef9fd287f3116cf45"
    sha256 cellar: :any, ventura:        "c3a290929befd7d8a2023e415634acf2885e2efae061939a3ea2700a8b37c1b2"
    sha256 cellar: :any, monterey:       "41774893aad35731b748a6b52cab826aed0cf4a8b8a1b49725ed7061d5f34906"
    sha256 cellar: :any, big_sur:        "b2bce490e72a0bb0482e4460a0da1a23ae23b68977a7483fb6ca85e3fda49ab3"
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
