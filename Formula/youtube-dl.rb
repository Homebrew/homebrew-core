class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
  sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ad5e9003ad43032fd754f626a27a2ef277bedd41952f33e9b5a74d8e22d269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0ad5e9003ad43032fd754f626a27a2ef277bedd41952f33e9b5a74d8e22d269"
    sha256 cellar: :any_skip_relocation, monterey:       "f02c4dcd2a08ed53a58ffd43d8a59ac7e41cae058e24358593476492388aa3a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f02c4dcd2a08ed53a58ffd43d8a59ac7e41cae058e24358593476492388aa3a9"
    sha256 cellar: :any_skip_relocation, catalina:       "f02c4dcd2a08ed53a58ffd43d8a59ac7e41cae058e24358593476492388aa3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8765dadcc82d42b45cb82f4f83d0dec0c98ddccae8072314564860dba0b4cc"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
