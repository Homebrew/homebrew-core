class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v4.1.0/SVT-AV1-v4.1.0.tar.bz2"
  sha256 "184162d3db3a4448882b17230413b4938ca252eef6b3c5e2f1236b2fcf497881"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef9741a91c2155055fa3dd9682776ac0c59014e0757ea92c789c6d0592273b86"
    sha256 cellar: :any,                 arm64_sequoia: "dfd452b9d5f752a679a6f810fcdb3906b6884dbc8a279abe558dc61c9bfc3c8a"
    sha256 cellar: :any,                 arm64_sonoma:  "b3f0cea562b0fcc454889b6aa6f1453be515faf87600021de6a4351c3e6018bf"
    sha256 cellar: :any,                 sonoma:        "1fcfdbcd821d7267e82e58445931d5b8e6c17d40b4a3a44ff32f715c1b1edcc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58cb3abfa77fcdf297a32ba2715a53fd2cd60571ca776632401d6334ac03c0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ebe93ba0e92ec1fcfff2bb9b360e09442a90c91aaa7b5dcd2392c74d04a8406"
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
    assert_path_exists testpath/"output.ivf"
  end
end
