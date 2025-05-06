class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "5a166016ffb8af4cfda9e9d1efcd5613311a4f9e7aabd1f2e11043bcdf727bec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3b261bc8e27e6197d6b24a8ed49a9eda13d7a87fb638b7a4e330e04d44352a5"
    sha256 cellar: :any,                 arm64_sonoma:  "d7d1eaf9fd5a8778e75d0c4e5197839e54d924261d07439d3214f1ea9d424828"
    sha256 cellar: :any,                 arm64_ventura: "bb01579574ac56a5b14b3c964051d50e7b2b3a9b571d067b01ffb6af4ff04e84"
    sha256 cellar: :any,                 sonoma:        "95af84ead1e1c2ce43f96a745ba015d24b227e98a055d5ff24564de6549e175d"
    sha256 cellar: :any,                 ventura:       "9b18ed226c81c8829b1743ab67e6fd0ec7296dc2f66bfc1e4e14739c84a6953e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22612118e95f41c2654abeca3b956fae8c63f0333924c46b500c746644ec939f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4f0b41a0e0d7e685b7be927ae8f6b18a24b90dd53446df6b8ad21cba89ff94"
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
