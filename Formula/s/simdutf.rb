class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.18.tar.gz"
  sha256 "c4910a05100f9fbef710d732f626f58e21c6d896bc940ef81d061803f2ec76ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a828eb98ed1522227dbbe299d4c0c21dac74f2d27614d33bec4f0651a9c222f0"
    sha256 cellar: :any, arm64_ventura:  "0ba08f0fc2bc14b63bbcf6cc75fa90306243974e9a7e27d3d2d7e05d9ca3f0a8"
    sha256 cellar: :any, arm64_monterey: "177e31f95d22a4623230c7ee96110d8cdd1ba623c509ab95f942aa081c9cb030"
    sha256 cellar: :any, sonoma:         "79641dc40c1649be5b3b9eabec7675c8a21531aa6ac2402be2bacd329a12d35b"
    sha256 cellar: :any, ventura:        "eba5bcbc5d9757e4872c213555c0b173cfefb102685404dbe604329f1de02890"
    sha256 cellar: :any, monterey:       "8a87e3cce90f4d7774f50b8342ba99a547b32d791b8e3967f9fc97a6ecddd89f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
