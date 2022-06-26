class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
  sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bc7ca875b43074c1a7097674b900835c5358e80d81a177b1eecf0e69b77a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79bc7ca875b43074c1a7097674b900835c5358e80d81a177b1eecf0e69b77a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "a8da6929ac2005f3bf5e004ccd1f860c6368cc49ea4d4846a0b902d21cc0cb7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8da6929ac2005f3bf5e004ccd1f860c6368cc49ea4d4846a0b902d21cc0cb7b"
    sha256 cellar: :any_skip_relocation, catalina:       "a8da6929ac2005f3bf5e004ccd1f860c6368cc49ea4d4846a0b902d21cc0cb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d96e5082a83cd8d333f72f40592ff577a4c4ccf4e654ddf2c3e38fccbb5c1f9"
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
