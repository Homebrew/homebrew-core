class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "0d9f63e2f308b6b54f399ebbe3a02776b902a2670c88c28de2d75ea2197dc4e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8ef7bc62a51a5a931c6b8f7eec2815e3315124c880bb9ad5fc2a805300cd5633"
    sha256 cellar: :any, arm64_monterey: "2bed48ae7c979e6e78e5cca84224c62f5cab3ae04acbf19ed21bfe4aea153b9c"
    sha256 cellar: :any, arm64_big_sur:  "fa0a4dfca0e68c331e4e8cceda912480bb455135bfa95b149512f270d79a4bd7"
    sha256 cellar: :any, ventura:        "f2d2ba41c4cdb26cdde04b449c1a0b93cc228d982251c8603c3e1c2ed4ff9861"
    sha256 cellar: :any, monterey:       "919ad9598e1a45279a999c4a70f2e8dea9c66a60012a81ee5c62e58885e88992"
    sha256 cellar: :any, big_sur:        "d97a778640e2163dfb7663c9032b32b79ad10468f97de8442a7962ede2849fe8"
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
