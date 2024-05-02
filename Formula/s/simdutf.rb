class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.2.6.tar.gz"
  sha256 "ab9e56facf7cf05f4e9d062a0adef310fc6a0f82a8132e8ec1e1bb7ab5e234df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5e33b72615ade8031e9dd5da51b6df72e5f0c1e98c147137b7dd34ff3a703dfb"
    sha256 cellar: :any, arm64_ventura:  "49a036cb45bb3d1ffad1f5c7b3d4f505b9d85472e0f8debd84cfce41c5dc7b33"
    sha256 cellar: :any, arm64_monterey: "1df620da6af124a649dc206bd6f42bc9b106cf8dc055462b0272ecf47b4626ab"
    sha256 cellar: :any, sonoma:         "7e8e688648446a8aa9d62d42b4c719564a248c07fcb2f5cced1ad25943110db1"
    sha256 cellar: :any, ventura:        "54582d65d9473ce71c3d6298bc311f3c7cf529796c8f95e0e3e6370c2264c211"
    sha256 cellar: :any, monterey:       "4ea02bc6f642c788d3fd835239c9cbaa477b267045ce446ed3d542437595c8e2"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # https://github.com/simdutf/simdutf/blob/v#{version}/benchmarks/base64/CMakeLists.txt#L5
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
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
