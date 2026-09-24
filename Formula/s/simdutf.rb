class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "b4b4f397065bb8f2ba2386feb40e58e27654c71c6f7521d9cbd32a16142bd040"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 5
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8837197b5daab1485f6ce8d84378a4c19ff6c4b231d0f2acc4ec1f77d0f7bc6d"
    sha256 cellar: :any, arm64_tahoe:       "22146fb0b58fa587e88bc67bb780e05ca96f343e601c0356c28d98b37b038367"
    sha256 cellar: :any, arm64_sequoia:     "0ad7aade58c0fd5fa56327b8efda8f663334109f00d4e03629195f46d8c021f7"
    sha256 cellar: :any, arm64_linux:       "7cb7fa0f90497b4587ae301e8e57da2ac76285305c8ac8d60c5beaf55cbd5709"
    sha256 cellar: :any, x86_64_linux:      "610ab653454d0d358f4a6b5a69e2e1346379f7ac0f966abf26eb10c4cbbb7a08"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

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
