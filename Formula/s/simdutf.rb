class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "98cc5761b638642b018a628b1609f1b2df489b555836fa88706055bb56a4d6fe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "dc353683d071621365c7aec115ae468b91fe1000b70ed5d7c1d92916930dedc6"
    sha256 cellar: :any, arm64_sonoma:  "d15a9acc7882a59ccbbfe84d2995ce5a267fceb97afc0a60fcbf3e1919d62224"
    sha256 cellar: :any, arm64_ventura: "abd012cd1ee98bcaad973b1ecaf82bf993190fb370b88dc09584143f9fdbaec7"
    sha256 cellar: :any, sonoma:        "0dc994d9a1987c57d6c655338684247b351274e968398ba24bfa6b83b3c989f4"
    sha256 cellar: :any, ventura:       "0e18dd000b52cf1b04f7a65acb0cf949864f14ddc164f0236fd6c5651fe6b58f"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@75"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
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
