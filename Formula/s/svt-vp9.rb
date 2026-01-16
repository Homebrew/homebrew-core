class SvtVp9 < Formula
  desc "Scalable Video Technology for VP9 Encoder"
  homepage "https://github.com/OpenVisualCloud/SVT-VP9"
  url "https://github.com/OpenVisualCloud/SVT-VP9/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2385fee19ea82c3e6157215ffbe1851fdabd46d1502e4343c842bf7f9bf662cd"
  license "BSD-2-Clause-Patent"
  head "https://github.com/OpenVisualCloud/SVT-VP9.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f651f843f3c74d02f346f08b5b5cb2c5fac49a13d63d24a6209b8ad6801a6625"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  depends_on arch: :x86_64
  depends_on :linux

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtVp9EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath/"output.ivf"
  end
end
