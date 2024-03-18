class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "088d750466bf3487117cce7f828eb94a0a3474d7e76b45d4902c99a2387212b7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "30ae77fd9c7b734d37224f5bb8173a32aba41768bac101850890c3a0092502a2"
    sha256 cellar: :any, arm64_ventura:  "e5e60e1dfeb33ce8b29e1c08d24a40506b868af14b6d63361b5e842d74c4fea5"
    sha256 cellar: :any, arm64_monterey: "06653c5301b485806317f1591adc77898bb9dd2a149b8f02530ea0e141132ac7"
    sha256 cellar: :any, sonoma:         "c0d1896d49ee43f6052fb63c962fd9d4e4e9442346186c314a2d8bb6d1a9e74a"
    sha256 cellar: :any, ventura:        "6b6f3bf0abca1d2ac8f62dcd6e469137084978aeac40b3855a20d43e6d2fe721"
    sha256 cellar: :any, monterey:       "4627515faf3b6fc858265a558ede91f4df3f4e60c3894c29e86cdd6026a6a51a"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
