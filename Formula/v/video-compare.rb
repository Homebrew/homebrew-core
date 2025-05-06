class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250420.tar.gz"
  sha256 "cfb1de9608fa141defa44b62c10ff7a56ea668c87d6c2c102409bddcaa98cd83"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c5125f72c106ad0de9b066a00ee77ed43751b807be6caad411530ccae8cf572"
    sha256 cellar: :any,                 arm64_sonoma:  "91c960962a8409b7841aa0b2a388d4ab1f2c6b5daf41c9472d44a959a3fb1c67"
    sha256 cellar: :any,                 arm64_ventura: "c3a662d5fa05837480826ac2f95024af62e3a74fc30a907f2372fbaf98fb5128"
    sha256 cellar: :any,                 sonoma:        "2ad8afdfb80441451a6e2a123349192ee6baa8c23477b62852e516716ad4dac9"
    sha256 cellar: :any,                 ventura:       "cf796389a2bff83b437f3a7fe226b0316f6422d470a21e32815b8c8d4e54f7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d95f27e30d009906f937a6a65afe3d93fc8362b424780c61fa1664c65413adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f666dd06227df40270d1e148a0b712f8545652baf0ab9332b4cfb0f70f41e363"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = fork do
        exec bin/"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
