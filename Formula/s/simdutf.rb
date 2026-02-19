class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "a21c34c52d91a229591e4ebc8822a876604cf2fffeac9ec065bfda7cbfb9d680"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59500b21743758c045a90e8a329ee2da10f252380780dc17e8e0ec9d55d00234"
    sha256 cellar: :any,                 arm64_sequoia: "2d43bb23e7154e345015e7197b5fdc79a196d3ce3642cef631fb1f53dee94f84"
    sha256 cellar: :any,                 arm64_sonoma:  "5128dbaffa8ffdb1721655a951697381da10b3199b1acbb19cc18526af0b4175"
    sha256 cellar: :any,                 sonoma:        "927affb7b2cedfa230dfa19b2d7fa03961b0b2dc672ded12f82e03348df63423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4ffb74e6fa33a85b0b954552feee9f0b3220de6df9259884e193f8db1b4949e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba31e56086959853739982e74a18823808f8ea5b9d43dd246ff7e3c63a9f0880"
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
