class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "5a5c84c05bf30d681126d1dcbde903615f2c927e201e0c6d489f74a91b7f506f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c237429376ec19e251c3178c2287de307a71d15892c31a7631c44a1bed16935c"
    sha256 cellar: :any, arm64_monterey: "f92fde933c87c20e700b9f9179dae7deb1f27dc5ea710b882e9a06bf4ce9ecf0"
    sha256 cellar: :any, arm64_big_sur:  "6ecd18d8a92c36d27c45a8064b5e3e22385d64877bcc70ac61178dc654d82ab2"
    sha256 cellar: :any, ventura:        "db805bbf23db4ab3bccb28be6b0292a597f5cc719df4d9cb3c729278d1c9d140"
    sha256 cellar: :any, monterey:       "ff7c33a658bb84015b0763b13d5213cdd0441d126b2af3ecd49c3a8ef2b7c6d3"
    sha256 cellar: :any, big_sur:        "8971ac87d2aab06fb0d8cd84c4afb812bfb98e6a048f27b38ea23c2368cca413"
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
