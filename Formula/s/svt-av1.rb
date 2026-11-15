class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v4.3.0/SVT-AV1-v4.3.0.tar.bz2"
  sha256 "9223ce06e6172ad41357ed23b3b00f036e03794b86b0e20ea9ccb3f648b8955d"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23723b4bd9030c4bf9145e18c88778cdbe54e07a64bb606200086bd6ffa1189b"
    sha256 cellar: :any, arm64_tahoe:       "8e980b08d0073e24fcd7ce255745020719396cc96f6ce83dee146722e210a5e2"
    sha256 cellar: :any, arm64_sequoia:     "99c39895e407e8a344ceb3d4139b102cab2c35e1b380051b19b3896ad82975bc"
    sha256 cellar: :any, arm64_linux:       "108d507b5c086765bada251c4f8fb8739841af3feafcced38db5e5ab7b5ece09"
    sha256 cellar: :any, x86_64_linux:      "d9279e447a7181d5b8bc0950669477912f2bfb9e13871648eea688f00265fda2"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-testvideo", :test do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  allow_network_access! :test

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
    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath/"output.ivf"
  end
end
