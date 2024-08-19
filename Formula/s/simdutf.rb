class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.3.9.tar.gz"
  sha256 "200ab9219e74ff11038eaa7a3d8e0f0fcf837241be6e60ef43238012aa29be7a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "651c7ad6a22c6cc5dd0932c772a73b31bd2512ddf424659eadd4ba0e8f3ea818"
    sha256 cellar: :any, arm64_ventura:  "ad5019c8033988a8aab10acd4c994d23cf765c11754b5859f87d821fb6757bc7"
    sha256 cellar: :any, arm64_monterey: "9a9592814b99d43119f6ed47119192f2734ce3ffea5e9b599a70b38580b6c82c"
    sha256 cellar: :any, sonoma:         "b2882e217c926ae4549452c2213d65f5ab1bf3dafbc342d1f56a810215acbb38"
    sha256 cellar: :any, ventura:        "a44d779525de6c5c80d877e49bb91e39d13134fc50182e1e2f9bd1a6a93f05e3"
    sha256 cellar: :any, monterey:       "08a4550a1096e26abd0c5ecd445cd7f34e21a16e9b0932354063702b2b5fff7e"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
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
