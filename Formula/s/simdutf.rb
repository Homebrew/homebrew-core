class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "033a91b1d7d1cb818c1eff49e61faaa1b64a3a530d59ef9efef0195e56bda8b1"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 2
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56791948a39b8168ee3c09b3edb14c10a74128cb31c5ae657bd06ef3e0bd70e8"
    sha256 cellar: :any,                 arm64_sequoia: "fbae7033d15b80e26b701addb3087ef625dfe97aaa53fd95f5410888b7adb9ca"
    sha256 cellar: :any,                 arm64_sonoma:  "4414605c28450d470c5f7bba822169e1ee5c2146e23fc1a86cc98a4421db1497"
    sha256 cellar: :any,                 sonoma:        "93437b4c4704da0b62a8c03d2f002838113c96f785425c13f599d42eb7e81674"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aebe9359204e366fd840260797ca093f1271a316785f6e58b5bb743df3f1ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651366aac48dce77419e10aa59b1aee36b79fc866c08a73946e85cb5c398f17d"
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
