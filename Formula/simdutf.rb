class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "9757a04085ad3ebab9fe933d9198ec6b84a857632a540418b6cfeb7b889a8017"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "90ab4d3b107d95ee82941560c14ca9ab9912829965c6ae7a5774efecd2092c7c"
    sha256 cellar: :any, arm64_monterey: "19bbfffb80455f1be3cacf8398c666acb46e358037f4918c775ae0f8ec5240ea"
    sha256 cellar: :any, arm64_big_sur:  "6bcd4b61d7063fb60ee335922be5e283e42c875832a941e461ab10de475971d3"
    sha256 cellar: :any, ventura:        "e490e2e4cca0e8478364e7292c5955bacf5b7e2860ba3cf3465b3020aa5a29bd"
    sha256 cellar: :any, monterey:       "4eb2d1eb0d5dc853e027dcaca9e6be2cb2b3ea52499ea212f5e687732d435883"
    sha256 cellar: :any, big_sur:        "d8f8b95dd77a049728d8ed177d0f4260294afd97fae386eb468d5db865756c80"
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
