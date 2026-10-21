class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.3.2.tar.gz"
  sha256 "d92a0a4ce216dcebf18af20fed7ea7279fa535683f790fdaeed39827a234f567"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 7
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2f2f09ccee21e6b73a3c2a6d37a4228a1a26fdd2904d63f3bf59bfbab5e2428b"
    sha256 cellar: :any, arm64_tahoe:       "d5d3c3cc35bcca3961ff5ad2515c84fc3310e8d69bb047a9403d97b8b919ce2c"
    sha256 cellar: :any, arm64_sequoia:     "f9e43522d4d1993441aa14a7ddf9aa303bd85f9f5993fcdfd84af681052a4ae3"
    sha256 cellar: :any, arm64_linux:       "552cfd43ccbfe02710b8d8d303c8f2260aa3b84cf63e03422d5a3f444102cabe"
    sha256 cellar: :any, x86_64_linux:      "cb8505d258329c509158f75f64bbb36bdccd75af12b894cd207ab06dbd49ca21"
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
