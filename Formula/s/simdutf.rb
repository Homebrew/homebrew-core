class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "f3ef16cb86d866d2271a9a2a539b6ed9ef9083d524963919ce6792a0e3750fe3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2595ffacfc4d6524b899d577e21e34b2ef83af412ad6bd05153c9003c971fff8"
    sha256 cellar: :any, arm64_sonoma:  "c5d21cc5f174a7d626f04aa1db15aa10a2aaa3e1694e694bee27c137513f66e3"
    sha256 cellar: :any, arm64_ventura: "ee5d83101d87f1c5738abd8e3883bf0066212d989de88e9ee5ef0b427658f2cd"
    sha256 cellar: :any, sonoma:        "2e1bd2b0b7f126b045f00448668158ddb048211d348bf1659c62e8fe8a72bcb5"
    sha256 cellar: :any, ventura:       "7f8dd6d17af6718a1fe9f4d3d6f32dfd6a2544e16cc75f2c061259cfc501c4e8"
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
