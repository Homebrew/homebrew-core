class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "3cad2f554912ecd77222272e5d1a7c1e5e33b4011bee823269cdc9095d2fdce2"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b224b133d0d629c2611c002cd0bcf0735e1fa4d02a22839af5c4a7d69475b9a0"
    sha256 cellar: :any,                 arm64_sequoia: "971f75ee152296b21635959d5a02abbb87360b17243ccc76f4009f895e242330"
    sha256 cellar: :any,                 arm64_sonoma:  "a545a48786969c82a8260597f666b37f10f2f32adc171308305f5e76495e54a8"
    sha256 cellar: :any,                 sonoma:        "f719a9f1cef84e77da7718cb9a929b7fba6fc46ca31c6d5fce24246ee5a3f7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8a96dc0a76595dcae3be8a7b4316ff0d223d7b4aa5bd2eac7d0968831cfa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6754936171667e06337dd064750908124f8ac52e3e7c116187daaf39732e1a95"
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
