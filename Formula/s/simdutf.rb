class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "26348c9b60bcf64b98dc598e0b8ccb3f0928cb991110ae82730e563ae85f2c05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb461ef58c18a59760093e5f205e7ca31312d426e24278c2979371f86e5f1429"
    sha256 cellar: :any,                 arm64_sonoma:  "6daafde3e962ce2ae4fb5ee3649a1f43806e0f73e07b5c203f9215e102a092c4"
    sha256 cellar: :any,                 arm64_ventura: "a855c52074b0b4d67c5a1cb5715e717940f91052f5bba7efee940803721ee158"
    sha256 cellar: :any,                 sonoma:        "a20dbc82e99e94b6b02d9788a3f215ac80e13d847835dfde28b9d064037d02f7"
    sha256 cellar: :any,                 ventura:       "6c0df9d339170056dafb5ff3122f1f7604d8e85dd272ae70838e613abe39cfe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a5ab25e7fb80f040a40f6b4af4d429dee942c08b8ed5c993849af37da1c016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b06473889ce106e5a0a77ab4b23960636fc0411437fd6e257c1f3a3eb0162f"
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
