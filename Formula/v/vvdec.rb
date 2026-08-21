class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "fb722da3c4d0a562969fd9540c67239e6265ae1e664ce563ad586e78ef4adb3b"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac334c9453870feec5f53bd68b6adbb0952346c284d2dfb69a4370ffec3e7748"
    sha256 cellar: :any, arm64_sequoia: "ab2201aef5ec5002cf5b2f503bfc1d9af6705abe0516adf96846ad2e7e75d3c3"
    sha256 cellar: :any, arm64_sonoma:  "812ce3187c0a683f3aa5658f3cb37006a27340c6ec7cd85da3a55ddf5b59cfb6"
    sha256 cellar: :any, sonoma:        "fcabb75ea21c8072ea15b5c3f7b0b7a02c8e97816bb9af00d7b6a52368713d5b"
    sha256 cellar: :any, arm64_linux:   "e6b12c132b791c7b8099d9f01ff7dcfae53d33a06ae13689a64a4f2c3a91abf2"
    sha256 cellar: :any, x86_64_linux:  "84b271ad50fd7f2916d6026f000cc0c7178c6976dc91df85213af9a1ab1ff23f"
  end

  depends_on "cmake" => :build

  def install
    # SIMD implementations behind the per-source `-march` flags are chosen at runtime.
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test-video" do
      url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
      sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
    end

    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_path_exists testpath/"test.yuv"
  end
end
