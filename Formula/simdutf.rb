class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "9757a04085ad3ebab9fe933d9198ec6b84a857632a540418b6cfeb7b889a8017"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "433e46cada05af1c2b34d4e0b2b2714747741152a875220e3d22bfee7be7cefc"
    sha256 cellar: :any, arm64_monterey: "51cd80b18b98c9126a6e48357fb6a8702999c7ca808b741d1ba87919b35b9dcd"
    sha256 cellar: :any, arm64_big_sur:  "b83934117fe72dde163b8847a8ae0fc9259034ef86b5486ada6e31aeda0b46a2"
    sha256 cellar: :any, ventura:        "d99ad09cbafff0c80704008a9582acd1bddbf7b6d43010a1d70b98b2e3378e48"
    sha256 cellar: :any, monterey:       "47191311607841bce5c899457dc4c6dd067e4d20b8d7d4241b63409667ca44d7"
    sha256 cellar: :any, big_sur:        "5667997021fbf94a5089f8ed335ebaeb2ddf2e6f4124e25bfd1771f3c29c3211"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on "libiconv"
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
