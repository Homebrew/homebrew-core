class Twitdl < Formula
  desc "Interactive CLI tool to download videos from Twitter/X"
  homepage "https://github.com/reneboygarcia/twitter_video"
  url "https://github.com/reneboygarcia/twitter_video/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "02ab5e5ea24cb0d79078b61e52ecd1bab3ad94dd00a5c6ec2f71f0fbc92e6dde"
  license "MIT"
  head "https://github.com/reneboygarcia/twitter_video.git", branch: "main"

  depends_on "rust" => :build
  depends_on "yt-dlp"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"twitdl" => "td"
  end

  def caveats
    <<~EOS
      Once installed, you can start twitdl from your terminal:

      Interactive mode:
        twitdl  (or 'td')

      Direct download mode:
        twitdl <tweet-url>

      Check for updates / upgrade:
        twitdl update

      For full usage options:
        twitdl --help
    EOS
  end

  test do
    system bin/"twitdl", "--help"
    system bin/"td", "--help"
  end
end
