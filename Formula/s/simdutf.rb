class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "ce8c57ea0c417f721e5f0b4ba5e295de38bbd0086bc16dc9c9b1c099926576c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cad25be14dcf980cf369969fcab2476698898bca6388fdaff4ab99489afdfc7c"
    sha256 cellar: :any,                 arm64_sequoia: "5ba0a004dcdef3558f429e30fbdf32931b549a8b9054654187e62bbac2fc8b18"
    sha256 cellar: :any,                 arm64_sonoma:  "a77d13048a486897c1b760037771a3620d96ce42607d33b3f1f5311cabc9224f"
    sha256 cellar: :any,                 sonoma:        "1b2be540b01233b7f89401b27e21aca2e167f4de4bc41fffb46c539e5b4e4963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5be5d02dd5883c8369700ea9283db2a26f32c398e46b392aecc1ff8797a8e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66253115c22557104acb105bd6ef7f4e063e1a6c73203788ee60e29932670648"
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
