class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.4.0.tar.gz"
  sha256 "361555059c963a1e5d78f3c7d42f35a19722b0333e6385994ff0fe7d80a5786a"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 8
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "642bf404cb0fa5b6b646a05bc71c8f59097bc32fd37fa636b78c6964b06d1ff5"
    sha256 cellar: :any, arm64_tahoe:       "44656ee28b118a5c20d6035109df2374b7760603d1cf4edb5f3f86144b512368"
    sha256 cellar: :any, arm64_sequoia:     "a3eace0f87047daf1a4db3c2010af9059346562fd8125e04a2d055aa857cb888"
    sha256 cellar: :any, arm64_linux:       "25b9e110ff3219857156cbc08982f8d8e6a93f7afc9e9a5ed341db59c3ddb456"
    sha256 cellar: :any, x86_64_linux:      "3d2f6f5ed4a6dfa19b239cbc06120b48a09f37edade6d731f94ba8c0963912c7"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@79"

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    # C++20 is needed by `node`
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
      -DSIMDUTF_CXX_STANDARD=20
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
