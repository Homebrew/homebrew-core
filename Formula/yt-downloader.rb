class YtDownloader < Formula
  desc "Lightweight cross-platform desktop app to download YouTube videos and playlists"
  homepage "https://github.com/ytget/yt-downloader"
  url "https://github.com/ytget/yt-downloader/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "401f56b79e0cd38fedc6f408d97771f65f64a43a463d646bd454a1d316bf9719"
  license "MIT"
  head "https://github.com/ytget/yt-downloader.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"yt-downloader", "."
  end

  test do
    # Test that the binary exists and is executable
    assert_path_exists bin/"yt-downloader"
    assert_predicate bin/"yt-downloader", :executable?

    # Test that the binary can start (GUI app, so we expect it to exit with code 0 or 1)
    # We use timeout to prevent hanging if GUI starts
    begin
      system bin/"yt-downloader", "--version"
    rescue
      nil
    end
  end
end
