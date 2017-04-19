class VideoQueue < Formula
  desc "Download, Split & Queue Videos on your computer. For productivity"
  homepage "https://www.github.com/seyonv/video_queue"
  url "https://www.github.com/seyonv/video_queue/archive/1.0.63.tar.gz"
  sha256 "862d01132eecffe8e8fdca310a7d7d9d4ff99557825d33ad39b1967b5d2dd86c"

  depends_on :x11
  depends_on "youtube-dl"

  def install
    ENV.deparallelize
    system "make", "all", "PREFIX=#{prefix}"
  end

  test do
    system "true"
  end
end
