class YtAutoDl < Formula
  desc "YouTube audio/video automatic downloader via active browser tab (macOS only)"
  homepage "https://github.com/chaseungjoon/yt-auto-dl"
  url "https://github.com/chaseungjoon/yt-auto-dl/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ee118efa3bfc7a74f134ac9dadecc734c5586df982c8ac8a3e3f98e50a226861"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    bin.install "dla"
    bin.install "dlv"
  end

  def post_install
    puts <<~EOS
      🔧 Required Python package not managed by Homebrew:
        pip install ffpb

      📦 Commands now available:
        • dlv : Download and convert YouTube video for QuickTime
        • dla : Download and convert YouTube audio to mp3
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dla --help", 1)
  end
end
