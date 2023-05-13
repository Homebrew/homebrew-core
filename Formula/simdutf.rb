class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.14.tar.gz"
  sha256 "6bd6cd41e0e588312c3ae24adb297454bd9bd9622ed7443f41300d7201f233a1"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "110a58fd28919ccb3cde035e3b674c7f29ec4fb61a27d4ca2588b771576977fa"
    sha256 cellar: :any, arm64_monterey: "ce2d9e9f4e0ff2e8d1e29e39689ec8e86565fde9bd7cb60ffd67e60817b923f9"
    sha256 cellar: :any, arm64_big_sur:  "897b1eecbfd7d7eaccb909750866f80099032ae2b94b10230b0a235f01163ccc"
    sha256 cellar: :any, ventura:        "5b4a92f0e41281dae025317446130b5d864d2bcc598ea0599dd83ba9613eba86"
    sha256 cellar: :any, monterey:       "3c830d5dbefb052048fa6c843948716cdb67724dbd4cdd6175c1ef45d73a5e3e"
    sha256 cellar: :any, big_sur:        "f55326749bf5753bf829d24354673b7e1bb035baae78408646e008ad83c63e13"
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
