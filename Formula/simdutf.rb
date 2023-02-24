class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "5a5c84c05bf30d681126d1dcbde903615f2c927e201e0c6d489f74a91b7f506f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "ebe6a9025c9f78ebdb16b525c4459de52195b2ed5f90ab364d4f8b36bee5aaf1"
    sha256 cellar: :any, arm64_monterey: "0575b6ec23391dea888a811a03fc62869426208ab03988fc7f64ab0189c946b3"
    sha256 cellar: :any, arm64_big_sur:  "524d428c5d2f96e04ae27da1ed72152d47c457a2e847cdf2eb706075c4826bcd"
    sha256 cellar: :any, ventura:        "8fa829f3459e958877d502e903c76523f37f6102052b49bbe238cd61b3b22a7f"
    sha256 cellar: :any, monterey:       "e43ba6dff9f3786e540474640c0da6330c2400a189e6eb4fbb365f55da571581"
    sha256 cellar: :any, big_sur:        "3ed5c979a418c38801a77c9ca2b8b46d280b7634838fc3eb11a6c24630246b16"
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
