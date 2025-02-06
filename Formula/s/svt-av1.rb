class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.3.0/SVT-AV1-v2.3.0.tar.bz2"
  sha256 "f65358499f572a47d6b076dda73681a8162b02c0b619a551bc2d62ead8ee719a"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "605135cabe91df094a30c1fcbbbbce1915b7847de7ef8d46ab7bb0bee5c5f1e5"
    sha256 cellar: :any,                 arm64_sonoma:  "ae9857ada8e720c1554c6d46bf32c91b8c2b78aa07c0df4ea936ecd91d3e7863"
    sha256 cellar: :any,                 arm64_ventura: "6327e22f6630352beaac4edb8f7b362c92248d31078444e0981f6dcea172dca2"
    sha256 cellar: :any,                 sonoma:        "7b9aabe63f4fe63854e7e6ca8a23c20ee5c8aad1232a2da3c9e32cfcc516b660"
    sha256 cellar: :any,                 ventura:       "ea80f7ef7a52e89746296794dba5459524420bd68b26ef5df43e16600b1d1154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0912347393354e14ffc4198e0d56ef10b0defc45576a543dcc2a0a4e75cb8a74"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/Lib/Codec/common_dsp_rtcd.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end
