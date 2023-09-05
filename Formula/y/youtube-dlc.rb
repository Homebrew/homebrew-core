class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  revision 1
  head "https://github.com/blackjack4494/yt-dlc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38a8a9b4b1185436c9243073fc6cf527c359591da3e9d27f8985b12e9f31cbb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a8a9b4b1185436c9243073fc6cf527c359591da3e9d27f8985b12e9f31cbb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e44cfaae0a362478ac3a386fac50ba8910585dab6410ed8d6703794a26e5520"
    sha256 cellar: :any_skip_relocation, ventura:        "7e44cfaae0a362478ac3a386fac50ba8910585dab6410ed8d6703794a26e5520"
    sha256 cellar: :any_skip_relocation, monterey:       "7e44cfaae0a362478ac3a386fac50ba8910585dab6410ed8d6703794a26e5520"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e44cfaae0a362478ac3a386fac50ba8910585dab6410ed8d6703794a26e5520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1628852cf9f8a86297420a1aa6d1f17789fa630f4eeef4c3cf017f6ac9f10611"
  end

  disable! date: "2023-06-19", because: :unmaintained

  depends_on "pandoc" => :build
  depends_on "python@3.11"
  uses_from_macos "zip" => :build

  def install
    system "make", "PYTHON=#{which("python3.11")}"
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
