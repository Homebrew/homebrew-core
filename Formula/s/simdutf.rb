class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "b4b4f397065bb8f2ba2386feb40e58e27654c71c6f7521d9cbd32a16142bd040"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 5
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6cea4a0e1a36a9cb2544c351faeead95e6d2dd8fd5ea6708395ecf6faa47d194"
    sha256 cellar: :any, arm64_tahoe:       "3810122aee9ff7053e475c1f9d87798751fec068426abddc59b0f5f98f83cd5a"
    sha256 cellar: :any, arm64_sequoia:     "0969ca3ea9bb8eefca86e143e56d848ec0bdbc1e0a752cd3f1734f3e13ba90ac"
    sha256 cellar: :any, arm64_linux:       "edc9a5846a643b63d352f918cd684deee47f3b1f7bf699bf91b124bf02a69630"
    sha256 cellar: :any, x86_64_linux:      "567605ef26e0b6e3e2dccb6ff3af810fcc1971a48225f0b042511566922f58b9"
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
