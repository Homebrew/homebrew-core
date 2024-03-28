class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "088d750466bf3487117cce7f828eb94a0a3474d7e76b45d4902c99a2387212b7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "12db089770ae059127e30c21f28be496e5ad357f07783e0e1d8ceb98394cee96"
    sha256 cellar: :any, arm64_ventura:  "7da24e29796a5ed6ba7c7176da306a7cddb159224f719a9ca7c65ddadfc71ad4"
    sha256 cellar: :any, arm64_monterey: "c8a853174c011164633e35fdc23227201eeacec7f4f7b601f1f8365a5b69a9e3"
    sha256 cellar: :any, sonoma:         "56d28a2ebb7bea9fc9c7dffdb53d8f63b72cdf51fd8b6af03f102eede12a5ed7"
    sha256 cellar: :any, ventura:        "33063ffed288b9a77156228d9745a082f6945714c43afd354005964d3919becb"
    sha256 cellar: :any, monterey:       "14d22789b1af18a7d84bd430ab8b48a897ce73aecba29b274501a56b4da913ab"
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
