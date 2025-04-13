class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.4.2.tar.gz"
  sha256 "4e58e35ba85fa914ed080c8075ac3fab8bc856d3b0a08fbacd860b9db4bbcf3b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e74ebc7883d702b369b31c27562b967927dcc1b050cfa926efcf7d770d47e299"
    sha256 cellar: :any,                 arm64_sonoma:  "a701f39c7137f59db8d4a3c0e50a6ee18ae0a1866b40d17d80993a53f7331ec3"
    sha256 cellar: :any,                 arm64_ventura: "357b774b32b843518568ba8e0f024d14a69b95195ba8ff5cfe0639c278bf97f5"
    sha256 cellar: :any,                 sonoma:        "aca5781d48032efbe3477ba580a4c60e6edf65bb2145ae0a63408701e9bca4fb"
    sha256 cellar: :any,                 ventura:       "cb5fb86025ed313f8a1a803412fe5445153277fc99bab91cf67a31550d3c80f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9612ccb6cccf2a10c0c99ab6e35a1666476f899937378f1a6b036a3000c27763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0e7ec69f2b950d0b4504386f3818e6e98b1076b7f794644e3267df159d7039"
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
