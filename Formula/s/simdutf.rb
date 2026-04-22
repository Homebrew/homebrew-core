class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "fd2ce975f29809a975a8da8843cfb3a7265af3f71be548f199d23cf65e101764"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 3
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a38c1bba8d023f968b80abdb392c149c2f5ae6930ddc1c929fb802a722c6aa54"
    sha256 cellar: :any,                 arm64_sequoia: "33afb526dbf507b29803dcb95bb330e7ffebefbae91a163adac64de941a0fa76"
    sha256 cellar: :any,                 arm64_sonoma:  "35f90e0abb75819daa2be40d549ea192b96151428d2251af8b46b69edc87d1a0"
    sha256 cellar: :any,                 sonoma:        "4f593577ae6fd8b39823ee31614b4680c231294120e57ebcdb1ec2541ec44b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec5770be1ff6fa05e99a3c7e631858531cc3fa5d0a108f20f064267e7e6af6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504e010ed49eddea6eab84fa38590da902dc798d33bce2a1e5469ccede396083"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
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
