class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "7a36c37db8f6dd36e03b1e894075c15f54dac6d0fe45026090eb56b941fcadca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0f586847bb4805352cce379a1281cd5db74234401c7da1c8cecfee72bab74dc3"
    sha256 cellar: :any, arm64_sonoma:  "87ff0c541577c57409af96c9a6c038f46f866a55d1966695cebe5c592e2362d0"
    sha256 cellar: :any, arm64_ventura: "fdb1aff026057d23566714333b88a50bc29f356d7564cd107b87c584bfae31db"
    sha256 cellar: :any, sonoma:        "098ae3f6a3096c74d3325178604f766b0733127fe08c5f60a41150056d8ccf27"
    sha256 cellar: :any, ventura:       "5ba3158352985ecce7e3059b541010dee830550adfd213a8e1c14bc6d4909ea4"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"

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
