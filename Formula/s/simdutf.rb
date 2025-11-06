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
    sha256 cellar: :any,                 arm64_tahoe:   "7972bee9a1aa832c0d81c74478f3a8b5f1339d893d9a374f3c841b938ecfdada"
    sha256 cellar: :any,                 arm64_sequoia: "cd2a793db1fe7b4aa0534163f1533c4c5ad4f885790ddee6a3faad0fd8234e71"
    sha256 cellar: :any,                 arm64_sonoma:  "7d8b79e61cfeb8ae60d21880f3f3af6f17eceb312c31155da3f1534b8f9eeedd"
    sha256 cellar: :any,                 sonoma:        "92a303d15cf1d5c47dcb98633204e39c512ea3549e6d1ed1f16965565e1c884a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4482182197f57f001dfc742e1ce4cd0ae03ad43824c090ae8b6a128b6dd3fd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89da0b6e00efab723c78189f7cc465f4e8a13a91e8cedb36e9a1e8760a29bf64"
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
