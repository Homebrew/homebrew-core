class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "7a839f9d8c32abb3f0c33c5242d8b2ac7ff0842b160421332cc8c291b32547bc"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bec1f532906895fbcab6f3945708e9125f2c7b190a7a09d2a6fbae31545a1e79"
    sha256 cellar: :any,                 arm64_ventura:  "540dad5f0ab1ee3212965e21e419a9b07474af093fc07e2b0383780b3eea346b"
    sha256 cellar: :any,                 arm64_monterey: "45d70ff578539419968b79d8683e8697f1e5b834b3e352029ae176c0d6c9a67f"
    sha256 cellar: :any,                 sonoma:         "06a00e15ce9c9b97bbe081b09f8fdf1cd1e4ae8ac01700a908f7752a1623e9cd"
    sha256 cellar: :any,                 ventura:        "19c306dbfc0129f424f3d2354be2908cf0926c0b0522aa6c57e9420a24f68827"
    sha256 cellar: :any,                 monterey:       "1a502335c473054fce98de682e88f979d4620b469b15e60535a8203eec3f6d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1852e9ce8681ecb8282dd0961f28922290650d590fd8fcaf356bb135c967fd10"
  end

  depends_on "cmake" => :build

  resource("homebrew-test-video") do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end
