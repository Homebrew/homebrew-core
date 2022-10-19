class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.3.0/SVT-AV1-v1.3.0.tar.gz"
  sha256 "841408b92c7b09957340112775369ea6fa763eaf4a8c10974cfa48f33c47a122"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60f346c5538a63f6fba100e1793b6da72d8e9fd8236f9db9369cedf5255e78bf"
    sha256 cellar: :any,                 arm64_big_sur:  "8c255909643b4303293527d0933816dcb961a35a6956b908ea77bb4e0bf86357"
    sha256 cellar: :any,                 monterey:       "27ac87dc9eabefe7d3623eaa7a8f15c58169411f1f5d349a63de1901abfe89a6"
    sha256 cellar: :any,                 big_sur:        "9a99c14d91208c8654d07a2c235207e563fe7d6e968e0ef92af8f02651ee8c19"
    sha256 cellar: :any,                 catalina:       "4d2d4f830f8f7fafca86cd30cc767302626159560ae8c3c07b41873f58d59863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9a239c990a42cb8e51ce6135b15a65addf98733c92de5adb6f807f51a032e0"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "yasm" => :build

  resource("homebrew-testvideo") do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system "#{bin}/SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end
