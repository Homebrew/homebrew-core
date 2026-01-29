class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v4.0.1/SVT-AV1-v4.0.1.tar.bz2"
  sha256 "df2a2dd51512717e8c3637072750a3899c3a69d684accccace33c1c467f7e852"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "414314961013ac08b3d045a4aeb05ed12c232f3c0ad9f0cc2665b6ebbd847984"
    sha256 cellar: :any,                 arm64_sequoia: "488fb41a50a872b777d159931d939351687fc0be76574b619678ab72af0878df"
    sha256 cellar: :any,                 arm64_sonoma:  "671b42e5accbdf0cff74d9915e5039ac8ffcff44bbe6167b3083356962bd7777"
    sha256 cellar: :any,                 sonoma:        "00fafbc444bfdaa3de880955328dc6cd19ac89f0771a1cc5ea6912cf54a712a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a5ff0f215f7a3e803b0276f96bc600e41592726b2a5cd6320c723fe4f579f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfb3507b2551f7f1219708028da07eb6a3ad22817a07ee459084620d6e7d3ac"
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
