class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240818.tar.gz"
  sha256 "29155c67c90307153e2b3c4a909083c9a7def710e3c0c4c9a7ffaa50398195d4"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a17fdb0881d933cb289dbb2a2889fde7cd8007fb377d90041e2db9bb348c2c16"
    sha256 cellar: :any,                 arm64_ventura:  "907933adc8eab74c9f21b6a5d55d005c9306facb9729544f4bc4f7523ea86364"
    sha256 cellar: :any,                 arm64_monterey: "fb2b305e62ef1b7792b85ffba6f927a372da008945856e3ccd70b950fdf471aa"
    sha256 cellar: :any,                 sonoma:         "1afbaf0dfb2766bc9091938f1bb398edd36251bb2d79ca97e2c1aebe780965be"
    sha256 cellar: :any,                 ventura:        "a61bcbab0b10c4e36960e3a73bb7f38c59c8d98dc6febbbdfa9590536a2d3f7c"
    sha256 cellar: :any,                 monterey:       "c5070b7597b576ea6a5fb1f681441893baef91fccdd5de485528892704e5b069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2693198a2dcc0078619c740c50a4b14d084a9ff3f59a3a8e3a6bded165c46ee5"
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
