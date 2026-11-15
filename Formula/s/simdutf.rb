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
    sha256 cellar: :any, arm64_golden_gate: "60a7060a9ff3caaaf4348eef3ce9b04e317edec4d75c00ac9a0723c59ad68489"
    sha256 cellar: :any, arm64_tahoe:       "d2f9a739ceb7d68ea26336cfb9119ec2f6126f3e4043cd525aae364bdec99c1f"
    sha256 cellar: :any, arm64_sequoia:     "5065f5ea109e365bdfb5ae4501a7037c87632a4b8a1bde9db8b2b265aa1cb945"
    sha256 cellar: :any, arm64_linux:       "0a10ec2ec0a26ccd8c6fc44f27504273e3ba1a2bb609bc2777bbe518e2be3a88"
    sha256 cellar: :any, x86_64_linux:      "b65a07ab592718c01e19512a1ada477b44e74dd94f8d241264efa422cf5d3674"
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
