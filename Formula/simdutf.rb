class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.12.tar.gz"
  sha256 "bffe41f74aef712f8c4b386827b6c64d5b2ca468d2ed48c9bd45eb22e7742009"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f211dfb608b1671c8329f446744601cb7ff9d37d621808a25098e87074a1d91d"
    sha256 cellar: :any, arm64_monterey: "0cd4ce2705485fdd21850adade920ef22bcd22420b99d3ae50d80bba023cbe80"
    sha256 cellar: :any, arm64_big_sur:  "70e7dac5d65237679dccd04af1ae26c6d8fa908fbc076334e305e182fdb8f885"
    sha256 cellar: :any, ventura:        "f938267ccf96eef9e9086dd53b8e55306291d7884546d1213fbaa027055f487e"
    sha256 cellar: :any, monterey:       "f2251674b7922dbb3bec6f036ce033b260d9861db9180bf810e78e8bc865763f"
    sha256 cellar: :any, big_sur:        "23a815673165fd19934f4505c3747220aced0099830591e571d52514eb3ee1aa"
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
