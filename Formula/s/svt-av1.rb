class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v4.0.1/SVT-AV1-v4.0.1.tar.bz2"
  sha256 "df2a2dd51512717e8c3637072750a3899c3a69d684accccace33c1c467f7e852"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7bebdeefcfa1362b2a1ac7cd354f72468b396e6b969a9aa21f5a0bfa331aa6b"
    sha256 cellar: :any,                 arm64_sequoia: "cf2340cca402d20b1ed309d22080259279741c7ff1e5326c317f2714f6ae2664"
    sha256 cellar: :any,                 arm64_sonoma:  "1c721eca3d502b95ab157653fb9deda961971ed750a2fb61567dfdf579badc0a"
    sha256 cellar: :any,                 sonoma:        "98cf4aab77023163121366a30dc3a224a6e0cabb79965ac8d7512a1888c361db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6deb25e23c0701c15e68d5af77d213fccd82f6c8d9463cb3f388e74e6ef202da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9573303a838e5714aaacb71f6ea7cb88b9bcd6063f0854b7db3c13bfdc0dc6"
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
