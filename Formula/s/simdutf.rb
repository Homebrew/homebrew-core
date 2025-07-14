class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.3.3.tar.gz"
  sha256 "6d720ecdd2e524790c0204561f559b755952d8a836a237b2b533f716ab6fdfbb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad783ca8bad002bfafc65e3ef1cbcd6f543c1f5d2a7ad666e335a5679c549968"
    sha256 cellar: :any,                 arm64_sonoma:  "19355057f95480af258b2c09b3d466e28dae149ba6a891b2351a58c77558f55a"
    sha256 cellar: :any,                 arm64_ventura: "d5e2eff8714032456c5a09bcc5d5b5e43bb6f26efd7855713557facc2b16f856"
    sha256 cellar: :any,                 sonoma:        "f2007c86cbff959840fc597a7af04feb7590a5f407cc3e6482a1e99044a135ab"
    sha256 cellar: :any,                 ventura:       "bcbf405cc3d0c5872f6621543c55a583c0b95e007fd59da12b829e3be9f11952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e069358b1c0478c334f03814846c2bc6679f3e9e6f07b1e731d2d9e2a97b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9349495e88c268262f565d962aebbcad33714cee14590dd166ba79df1be714d3"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
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
