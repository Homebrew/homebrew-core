class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "3651e290e97af000cef506ceffbbf05f412fd6100e1859baf0267d42941e1e44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6f4f2e5e053c70beb7843daa09e1a1716aecec8a12700827ad4fc9f62f5f850f"
    sha256 cellar: :any, arm64_monterey: "d3fbae321c28a688ed4d73a2b7ccf7344ef4cc6f7aaa7bd59c4dc9c6db46d160"
    sha256 cellar: :any, arm64_big_sur:  "f949e234f145fabb1f020f369baca0663209da959dfa015e9232c506fea93315"
    sha256 cellar: :any, ventura:        "b7bc51ce7d79ec083cb4652958f6c1462639c72111cb25e3e27e928581934c95"
    sha256 cellar: :any, monterey:       "bf4a7dff56c3e8cb186398da13dc974b011110e6ad8428a1871ba8188fd9d895"
    sha256 cellar: :any, big_sur:        "897ed2f62779c26bf189fe3db01235b84d36912709be0e99e044db48581011c2"
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
