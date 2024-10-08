class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "47090a770b8eecf610ac4d1fafadde60bb7ba3c9d576d2a3a545aba989a3d749"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2c35a27caa3f947f282f724a4a81e42fa966fa8d193f2ffda0b4ab764694a7dd"
    sha256 cellar: :any, arm64_sonoma:  "63c051def8c97473dfa5e5860b2fbcdfc3aeb229efc3a675b610328cb322ddf0"
    sha256 cellar: :any, arm64_ventura: "b850b7b69c9bc78628ce9715880329c565b31b24e53ad58dd6f7327b0fc3dd36"
    sha256 cellar: :any, sonoma:        "29ff5684e2e97b7037cbaebbbcf98f5b31bc5afc6c5904fa5f741c48b893fd5e"
    sha256 cellar: :any, ventura:       "51e2a2f86c90edb68f0eac2f74904faec32b1bacc24aaded72b542fef5cacdf2"
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
