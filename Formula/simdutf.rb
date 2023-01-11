class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b0b8527e194700363cc47e75a7b8d58c88798b0dc31671f5ae5c8803d8678fe6"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e6825e72748afc94e25cacb2e522355533d3760b3c2c95a81df4ef61eb572924"
    sha256 cellar: :any, arm64_monterey: "c2bcc45100900a82e502d458dc0bf8971583019c364b16ac34e39d418151edd7"
    sha256 cellar: :any, arm64_big_sur:  "819ac7a77bbc6c77ef7a5debc16f9927497cd0e4b6fc769b3a93189429378d69"
    sha256 cellar: :any, ventura:        "3c896f09b238592b9a77f89c8aa78ab55b09ea5608feb0694dee37fca3b702a4"
    sha256 cellar: :any, monterey:       "33c38f0cb7148d57300bd5b12a74ba7a30d7814ec0d03a427dab4aa552e2e299"
    sha256 cellar: :any, big_sur:        "4a82317135b4c057903572301c7c3cef9db6b9429d2a4ce2e8ea37d904d68a90"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on "libiconv"

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
