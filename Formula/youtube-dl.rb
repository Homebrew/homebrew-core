class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
  sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d54237a227c12efaf38fd29deba9954fbd9bc5dac5404c70c9e34d618e3389d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d54237a227c12efaf38fd29deba9954fbd9bc5dac5404c70c9e34d618e3389d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d54237a227c12efaf38fd29deba9954fbd9bc5dac5404c70c9e34d618e3389d"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4a60b76c7aaa2ac750e92f7cf7aec386539aeb2d8d77054d087e6857b54dea"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4a60b76c7aaa2ac750e92f7cf7aec386539aeb2d8d77054d087e6857b54dea"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf4a60b76c7aaa2ac750e92f7cf7aec386539aeb2d8d77054d087e6857b54dea"
    sha256 cellar: :any_skip_relocation, catalina:       "bf4a60b76c7aaa2ac750e92f7cf7aec386539aeb2d8d77054d087e6857b54dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badafc55a0e6036f92ac52c82c7113630409752921d4bdf6801ce8f8c3efe816"
  end

  depends_on "python@3.11"

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
