class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.0.3.tar.gz"
  sha256 "3932bc91246d72a8e79c8aba17fbd4740468d0f42c0bd32bb156e97264a7a3dc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e4e6f6c35a03b5298d8fc5e903f4f052f6a836d714182f8cdf8a6a249fd95a3c"
    sha256 cellar: :any, arm64_sonoma:  "78d81462239a71c50179a65e9ae63bda64ab170e1a0f54e97db4f765ab2e4265"
    sha256 cellar: :any, arm64_ventura: "0847766dd42149d771e60db322a329e54bb8b65c8feb1031b0a6cd35bca79b3a"
    sha256 cellar: :any, sonoma:        "1f6835d989644af3e6db2ac1c785b37c2e14bb8ad539d78e773baac200c8bc3f"
    sha256 cellar: :any, ventura:       "680f6afecf5b1b5e35330e5351e6eb34d87486e961f52f66b8fa5cf8cab9e056"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"
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
