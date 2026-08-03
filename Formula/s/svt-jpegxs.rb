class SvtJpegxs < Formula
  desc "JPEG XS codec"
  homepage "https://github.com/OpenVisualCloud/SVT-JPEG-XS"
  url "https://github.com/OpenVisualCloud/SVT-JPEG-XS/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ae04de9afe2c086a15da85ff7473ec1db127c380081c11c8860f958e8454f0ff"
  license all_of: ["BSD-2-Clause-Patent", "GPL-2.0-only"]
  head "https://github.com/OpenVisualCloud/SVT-JPEG-XS.git", branch: "main"

  depends_on "cmake" => :build

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-testvideo", :test do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system bin/"SvtJpegxsEncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv",
                                  "--colour-format", "yuv420", "--input-depth", "8", "--bpp", "4", "-b", "output.bin"
    assert_path_exists testpath/"output.bin"
  end
end
