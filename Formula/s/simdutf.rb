class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "85a29bdcc2780ab473a0912d7a8259f85a98a2a661e7497d46b8e323840a6aac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "afeb1b3d5b772e5bd0f6a15cc18b1d1276a0d07635ba47f56e7282a50de9c9fa"
    sha256 cellar: :any, arm64_sonoma:  "0213e99f12a29eac90c759df34662d97fa1daa529d2cea76e226ca97945e31e4"
    sha256 cellar: :any, arm64_ventura: "c218416b7d33048840cc881f3fec58eaffd3ac9ac0eacc67e640560731a6f49e"
    sha256 cellar: :any, sonoma:        "023e71a643f36290c0fc15ee5715b2c8e3d13348e12caee310a409781a2a5cbc"
    sha256 cellar: :any, ventura:       "a3638306ec1e24d65076e279d8011f12d9f878f2f18ab9ba5fa8cba29d6b0ce0"
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
