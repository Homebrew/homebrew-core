class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.9.tar.gz"
  sha256 "599e6558fc8d06f8346e5f210564f8b18751c93d83bce1a40a0e6a326c57b61e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d6a460efc256ba88e1613af84096aa0448ceaa386619d26bb83cf5ccb4c1feee"
    sha256 cellar: :any, arm64_ventura:  "84a3dc9d1055b374bbc2d9e36583611f9f548d250dd6bde8c357003e95c3cf76"
    sha256 cellar: :any, arm64_monterey: "b8add4a106ea999336220005448a4d91b9e943c9d75f8cc0353ef76ef029595f"
    sha256 cellar: :any, sonoma:         "c759bbcef26f397eb1c10e53847345f5e8268651bed50570bd9845237a3a2ef8"
    sha256 cellar: :any, ventura:        "c4122b60b5ff6632e19bb6db2647be57625db15b17da37f4570f1f5c9bca5849"
    sha256 cellar: :any, monterey:       "f1fee085f00cae7700521138081ff07a9845308d88160ffadbc37585f5f608a9"
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
