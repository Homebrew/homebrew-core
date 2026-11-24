class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.5.0.tar.gz"
  sha256 "833a71de6224a3370e7116af1a2c2e666a6a9efe63c41198e6197f7e047674b3"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 9
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7991b2649090294f90eb3d1f7763f63b7396930b954fa14969c9fccdc4bece3e"
    sha256 cellar: :any, arm64_golden_gate: "419f290b540c18ea00d62f0d28344140fdec80040ad590271fd4d22c829496dd"
    sha256 cellar: :any, arm64_tahoe:       "423b54a2c363c43655a47a43a2340d08c25140cd25113581d7eec2bd7dcc39f7"
    sha256 cellar: :any, arm64_sequoia:     "fdcbea59c406d94a07c3fc92505b649abb2022317114f44ff08a31701b99e51c"
    sha256 cellar: :any, arm64_linux:       "47ec558dfceee7346105b3ac09e393a35ca8ef25e0aa64604eee0b4510cabd3e"
    sha256 cellar: :any, x86_64_linux:      "bcccce506d6e9a91a8bba0c2d26e67b67090c8c987bbfeb63860e68a863f10d9"
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
