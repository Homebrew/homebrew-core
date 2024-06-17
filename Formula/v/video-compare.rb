class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240525.tar.gz"
  sha256 "7a8f559da1f069270495bfabe19cde4a0102187812afbd6885430d4a7b3bd9c2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b73f4ff42f2b8132f782b7a4866a02acd7c9420586aa5092e1feb8a6116892d6"
    sha256 cellar: :any,                 arm64_ventura:  "f753b5e47084f5d4eae88127bc4afd7177968e65a50bc057daaf7b7e6a127218"
    sha256 cellar: :any,                 arm64_monterey: "4ca06931868379ed17568c780365e44a709ce6849a397c977da4ebbfb7beb194"
    sha256 cellar: :any,                 sonoma:         "a3981c1c5b3f4a25688bcb0502ca207fc7173fbbdc337f92b5391fb943c08909"
    sha256 cellar: :any,                 ventura:        "8365fffba9948b99ed64ff3ef861cf95ee45433975a490d8f7a9d0bb0498ff6f"
    sha256 cellar: :any,                 monterey:       "fa44a0b6538d0881c49beafb15c0a3a57063158625ae54576048aaad6c7fbb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e93e3fa6744b1b6b5e4a9b7a01c159fd246f7f972485b5b6ec324af9318ad7"
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
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
