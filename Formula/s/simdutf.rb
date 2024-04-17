class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "36281d6489a4a8c2b5bfac2d41c03dce8fc89ec1cda15cc05c53d44f5ad30b4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "13cf8d19e4379d44098c31add0236af302f8539129ff8b78ad23033ea526477b"
    sha256 cellar: :any, arm64_ventura:  "260f892ac64a528ba0a5aa13c6aad5827dffd7d40f4e8b81d05f73bef29ca396"
    sha256 cellar: :any, arm64_monterey: "bf305eebb1c5c167597a131130c8b50e7a94844a090c51ee467e94555833b986"
    sha256 cellar: :any, sonoma:         "7c58ef3972ee593e3d26871f475b6a3e742ce747e42aaeb0f5f713d11d294a7d"
    sha256 cellar: :any, ventura:        "9139e07c169b5f4ae929e4af97b789e47d454ee4232cc7c60d85b29b033ac24e"
    sha256 cellar: :any, monterey:       "efdb7a90da1352be6df687f46c40d727d3ec31321a170f1305434f3e91078092"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
