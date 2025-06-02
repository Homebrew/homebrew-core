class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "e337abe416898d1d997d729cc04370c89c8dddf688648e876f37970e98cf93aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a9b20ff5eedd441325216819e22e42420200f7738ccead54dd1aee9dd99d557"
    sha256 cellar: :any,                 arm64_sonoma:  "6cb738dbfcba72277f7bfea52b0471577ab23aec6fa8bc4f27e004513f1b5529"
    sha256 cellar: :any,                 arm64_ventura: "40c3c1577a8c5494a3dc22a3ba4f9596c0fd0550a197f90c3e248dafffbafe3b"
    sha256 cellar: :any,                 sonoma:        "86917209f8009cdaaee70170adbe529a204ef6742ccc9099f94a94feaa38d5b0"
    sha256 cellar: :any,                 ventura:       "e59bf45c9a87d09b451b6023904b138c572aebbbf87da540b86f6bc0894baaaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81a1452432282fe777d02cae642c9717cd6f0bf08d73bb0de3325c4a0027e223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f0837ac8f666e8f08b813c0495723014c7be124849938bde434808087acb2e"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

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
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end
