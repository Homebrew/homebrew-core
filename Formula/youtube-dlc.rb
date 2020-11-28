class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  head "https://github.com/blackjack4494/yt-dlc.git"

  livecheck do
    url "https://github.com/blackjack4494/yt-dlc/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  depends_on "make" => :build
  depends_on "pandoc" => :build
  depends_on "python@3.9"
  uses_from_macos "zip" => :build

  def install
    system "make"
    bin.install "youtube-dlc"
    bash_completion.install "youtube-dlc.bash-completion"
    zsh_completion.install "youtube-dlc.zsh"
    fish_completion.install "youtube-dlc.fish"
    man1.install "youtube-dlc.1"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/youtube-dlc", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/youtube-dlc", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
