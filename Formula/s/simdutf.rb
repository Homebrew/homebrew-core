class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.2.1.tar.gz"
  sha256 "582f9d0dcf578f6d4766fa29ea12a7f2f02bd3c6ad9e0cf35a8e0ec8478eba4b"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 5
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e5c1ae108e4d53384b38ad0a865bb58140b7c2c8e8528e9d8a7bd7810c03d83f"
    sha256 cellar: :any, arm64_tahoe:       "c0992a6098ad9b85df9db148ef58ecd82d712adabbb39016fe6b8a7c9bc1459f"
    sha256 cellar: :any, arm64_sequoia:     "47c8bfe62737cdda001f35e79375248269eacb81b259977aa9c75eaae0be623b"
    sha256 cellar: :any, arm64_linux:       "ac704b64b9877e89baa13c19c9b1c4997a68ea5b6f3abe1392ee63baed7fa564"
    sha256 cellar: :any, x86_64_linux:      "4dada8ea727a9f78c007cdcea0b29d33c4f2639804f9dc611f6271d70a0e9346"
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
