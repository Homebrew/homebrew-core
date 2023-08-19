class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.17.tar.gz"
  sha256 "c24e3eec1e08522a09b33e603352e574f26d367a7701bf069a65881f64acd519"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e47da9bcb4afcd60d9378dbd36186a646ccd17e0ff2863e3ec8885709160b090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee98252314db62b8306d26e9d2468408dd3718cae28f3db15e2274f22f0c1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75ba65683f24bc6aab82e88147783bf2b55dab87e4b28204e02e59f2013621f1"
    sha256 cellar: :any_skip_relocation, ventura:        "45671f3cd92efd2353cab9ddf3626cea80b820e9b39c8a55667aa7d182e10e25"
    sha256 cellar: :any_skip_relocation, monterey:       "1746c5e39177dc930f838c2c0bf5bf584adacd640cc84b936a06f6e107f5e3fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c4f97ed9d907527660fbf00e2ef3c19d7ab7779439b594b93988e4beee11d6"
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
