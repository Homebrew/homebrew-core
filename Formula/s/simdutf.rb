class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "0180de81a1dd48a87b8c0442ffa81734f3db91a7350914107a449935124e3c6f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1229aff57b00935c1e2b9ecb2d2425641a9c87cd69813f3ccb75e678b41cb98"
    sha256 cellar: :any,                 arm64_sequoia: "b198a452c36e80338a944741123847d1de3d30411137033e99b403463c3b03b1"
    sha256 cellar: :any,                 arm64_sonoma:  "6aa473eb7cab89664384be4fed9fceb26f08de6184415e576c79083da80aaac5"
    sha256 cellar: :any,                 sonoma:        "a23a094529b8200dbaad8a34ad41c41af4b39d40743b36c085fead985ddfc1ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb559a2817b6bf057a8a3fc07a7a9d09ee22e4bcceb13091709b75cb4225df5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e07b1f7a85285b2a7a7b9da642f1e70d794efc8c32de7d087e5f853ac326a74"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"

    livecheck do
      url "https://raw.githubusercontent.com/simdutf/simdutf/v#{LATEST_VERSION}/benchmarks/base64/CMakeLists.txt"
      regex(/VERSION\s+(\d+(?:\.\d+)+)/)
    end
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
