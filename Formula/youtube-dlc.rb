class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  head "https://github.com/blackjack4494/yt-dlc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00c731f3aa0cac636ee980b19720eab0bf8e3fe19da5751addc8997bc491af08"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5b0155e1929150e4a35fc02513fc105d25e03fe778edd6db94302d9c50dcdd3"
    sha256 cellar: :any_skip_relocation, catalina:      "d18e35ee7120d9d76932338981585f68f42ff16ef91268d02ef58de4fb9f5c42"
    sha256 cellar: :any_skip_relocation, mojave:        "044a2108153ef9ce3e4e5e7b3e6602c5789ab6f4449511050dbdc4a805e6077e"
    sha256 cellar: :any_skip_relocation, all:           "4add7c7f13dc728e71280c0c00f7ab7513126539c82da4bbaa076667b6bfc1ee"
  end

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
