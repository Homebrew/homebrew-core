class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.1.0.tar.gz"
  sha256 "24e3510a4c95a9e6eb0fb4a27eea650d13773231cbd8b564ed9670aa5484d193"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 4
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d31bc2b54402cb07d30251da17c746843428983a91435fd2681bb44129c669f"
    sha256 cellar: :any, arm64_sequoia: "42bbc4e60e729a7053916e4c96e5b56a26af0c90b0fe61bc35dc0f66c7942991"
    sha256 cellar: :any, arm64_sonoma:  "baa9c69e438ce55454f7b51bd8d6df955a8023a80526f64192fcf964d1211795"
    sha256 cellar: :any, sonoma:        "990852bac0ee0acd3fe2032a7f46b5f320f440ba9422744fd7f57e0561e95647"
    sha256 cellar: :any, arm64_linux:   "2bc950e345a2a00603977c8486e934e228d6e17d9f632a715adcf9707a92d6a8"
    sha256 cellar: :any, x86_64_linux:  "21eea6cc5a2fc4e7d09a178a497b031cf981a4d7e3ed85707fe181be827bdaf5"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end
