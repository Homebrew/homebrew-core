class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.3.0.tar.gz"
  sha256 "f05b3549465f1bb3c5033a05395c372c0982ed1d166608185b3cc8c5c7e98071"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 7
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3b82534aef06319337f82e8d4ccb4391a9761eed92838a263108e26c6d42458"
    sha256 cellar: :any, arm64_tahoe:       "8b87bf83cc005de8e6ed52166d58c9c3b6961908ee2cd0dde8f25b00131b9400"
    sha256 cellar: :any, arm64_sequoia:     "6772b58998adc199ee3e9623ef2ee7e937eced9a1ab2ba9f0ea417b2402d788e"
    sha256 cellar: :any, arm64_linux:       "16efbf0eab8b79f60c8c46394a1df58729919d9e693475dfccb6ef41ebef1f7f"
    sha256 cellar: :any, x86_64_linux:      "3f4da72ae548ef0b1df1305f8b86b4ebb5fb670e17f929fefc877f057f834243"
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
