class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "c3666d18bd1b76b06b8f98ff384dfaf3c6fb0d9a61540d84fc65f39cf07bf234"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1f5e0f5803e300861817c8387d2a1bb4243244a39195051d4c7b4dd1ca28402d"
    sha256 cellar: :any, arm64_monterey: "07e53f216b7e1c9644526ccd71e3c9fd1769eaff12af92f6e23b765836791cab"
    sha256 cellar: :any, arm64_big_sur:  "a1250d1bf579ee8d09963daec8c5300acbdab1683a4c20d51d77f05e0406f765"
    sha256 cellar: :any, ventura:        "c068c8b74e76ab4982ecea3bd753c66f5e83249013d4da10eea4d82ce654e210"
    sha256 cellar: :any, monterey:       "654ae38e243d5e9440293bf300e83b58a474327792db5ad90a58681b8b938911"
    sha256 cellar: :any, big_sur:        "ba4d44286d01d75a729d1d9c883be72417ef7cb1cce2a425394803807394e0c9"
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
