class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a8a8bbd71c8d8be1f7da16722776988d0640758fe0a46066eb3129868dad08da"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

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
