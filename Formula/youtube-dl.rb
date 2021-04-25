class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/94/a0/b8325b524700daae1c04a6156473ab7091d44071353f1d7c9e66b9c7f019/youtube_dl-2021.4.26.tar.gz"
  sha256 "6f311ffaf8b88cdcf27a2301a2272455e213bdb780aa447246933a3da4532879"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86a1efbc3610e838caeb51e9f6d579c92d9a356243566c1c0b555486c76038bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "edabd75f725221fb12e7036f37e6921cae47ca2234f8e4e19062ca190b64d57d"
    sha256 cellar: :any_skip_relocation, catalina:      "edabd75f725221fb12e7036f37e6921cae47ca2234f8e4e19062ca190b64d57d"
    sha256 cellar: :any_skip_relocation, mojave:        "5bb2b85c53a5519077df1a9d2efd2bed1a4b52259e5ffc4aa6054de2f8383b73"
  end

  depends_on "python@3.9"

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
