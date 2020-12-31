class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  version "2020.11.11-3"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  head "https://github.com/blackjack4494/yt-dlc.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "96844d212cf5219f124b4c854ff05ada46f0438f99d47c59512c7da23c63de18" => :big_sur
    sha256 "b6e342ec4facc780dd947d75a5a945e1f724738103818cb734afcfaf0a6beed3" => :catalina
    sha256 "8a375f9a0651590aaf8259be15e84700f25ad6dba4a97dbeb57c74f3fa523e03" => :mojave
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
