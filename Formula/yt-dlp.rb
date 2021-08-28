class YtDlp < Formula
  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://github.com/yt-dlp/yt-dlp/archive/2021.08.10.tar.gz"
  sha256 "d847e32bc18767be2f27183f5da2ba05d0142e194e95ac6b3e69494353ee366b"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  depends_on "pandoc" => :build
  depends_on "python@3.9"
  uses_from_macos "zip" => :build

  def install
    system "make </dev/null"
    bin.install "yt-dlp"
    bash_completion.install "completions/bash/yt-dlp"
    zsh_completion.install "completions/zsh/_yt-dlp"
    fish_completion.install "completions/fish/yt-dlp.fish"
    man1.install "yt-dlp.1"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
