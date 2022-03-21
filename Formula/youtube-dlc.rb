class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  revision 1
  head "https://github.com/blackjack4494/yt-dlc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b783d95acf80bf416f5914825a6526f20a1cf2efaf796c034e7b681c77cf14d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b783d95acf80bf416f5914825a6526f20a1cf2efaf796c034e7b681c77cf14d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b783d95acf80bf416f5914825a6526f20a1cf2efaf796c034e7b681c77cf14d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b783d95acf80bf416f5914825a6526f20a1cf2efaf796c034e7b681c77cf14d"
    sha256 cellar: :any_skip_relocation, catalina:       "3b783d95acf80bf416f5914825a6526f20a1cf2efaf796c034e7b681c77cf14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1a851f379d37a98f7753ed90d6935b5075e02e19d62ae6f3584fdd9e377fa2"
  end

  deprecate! date: "2022-03-21", because: :unmaintained

  depends_on "pandoc" => :build
  depends_on "python@3.10"
  uses_from_macos "zip" => :build

  def install
    system "make", "PYTHON=#{which("python3")}"
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
