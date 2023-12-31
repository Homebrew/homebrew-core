class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "bbc1b5fdfec7d0f83c6a9d24bf90d10c2a462f30aa1ced30bed72288006a2194"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "eb3ae258c5e6f44f656ef24b0efae1a7bf75b348804e7b0da1e10f57d83028c7"
    sha256 cellar: :any, arm64_ventura:  "1bd856598d32e0301ef2e42e81e3e54f2e8d16d37b793e6f8800cf9f6c343e13"
    sha256 cellar: :any, arm64_monterey: "4ab981a23d29ff754df6fc34c3dfc9be81e3dda0d9554c989646a6e6e9c2231e"
    sha256 cellar: :any, sonoma:         "dc5a473ac2fac2ac52b725f68291359f1557a39e7e309b032f807b32552f050c"
    sha256 cellar: :any, ventura:        "a1400e87f8e301308cd74e466ee77576c184432f54d2c38b50e9395b8e958caf"
    sha256 cellar: :any, monterey:       "3e65eba6f985c2ceb0a7b7fbaf91ba693f7958cdae856a2104b3671a0da6a526"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  def install
    args = %W[
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
