class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.14.tar.gz"
  sha256 "6bd6cd41e0e588312c3ae24adb297454bd9bd9622ed7443f41300d7201f233a1"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "64933933f84cdb4685f060b3950d8821d78a2c091ab8f1c3a8e2ea5036cc4881"
    sha256 cellar: :any, arm64_monterey: "a126718094b9ec42eeb7eb4d38863fa1eb0e6d724f3eb3996c5bbb30daa8a9fe"
    sha256 cellar: :any, arm64_big_sur:  "8c3c74eca19712b6917a54a8fa186df4e2c0befc70b0ec7b1831084c2ff1caa2"
    sha256 cellar: :any, ventura:        "aaf181bc8a294cf41164422a1ff77c56530f3509a792be442a102bee15b38950"
    sha256 cellar: :any, monterey:       "2b2d5e8584054943669f59d480cba4a5281f58288f42918fa5a811ef3251da82"
    sha256 cellar: :any, big_sur:        "2807927d8f31266248795838f5efcfcb8ae4b91f485ceed6303625f0421580b1"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

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
