class SvtJpegxs < Formula
  desc "JPEG XS codec"
  homepage "https://github.com/OpenVisualCloud/SVT-JPEG-XS"
  url "https://github.com/OpenVisualCloud/SVT-JPEG-XS/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ff5dfb3b98348a39049da4fd3062d3391cbadec4c4b61825a9f3435ca671effa"
  license all_of: ["BSD-2-Clause-Patent", "GPL-2.0-only"]
  head "https://github.com/OpenVisualCloud/SVT-JPEG-XS.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on :linux # on macOS, *App can't be built due to unimplemented `dispatch_semaphore_wait`

  def install
    # Workaround an issue with CMake 4. TODO: Remove next version bump
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtJpegXsEncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.jxs"
    assert_path_exists testpath/"output.jxs"
  end
end
