class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260502.tar.gz"
  sha256 "558e9a97e381929fa6c30ec46e5187cf4ceb3505dffe8c0da0a581a0d2b60202"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc3c0fec10001f65404f1cd67d8cd257348a6da497c398acf42a1a881d850c21"
    sha256 cellar: :any,                 arm64_sequoia: "5726abc21eb979672204e19bd56f85aa10918f478d0996bb124b46c5fb74f4be"
    sha256 cellar: :any,                 arm64_sonoma:  "d28bcb6138a920cd3317af53165b806958cc7c161b06b6b775eff032693ef9dc"
    sha256 cellar: :any,                 sonoma:        "16b5ea0f93beb11832fa4a522a0aa517982aff6504234da333e07b1182225c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa08d155e466382fedf8f3d6db7c2889f9a67e7ed02f598657a4ea2ee131c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa9e13bbdf8e06f26e96260aee90e343b2337b20fcbbaa0cf022a3c20175b1e"
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
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
