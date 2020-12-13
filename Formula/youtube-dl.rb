class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/a9/0f/a731f1a70b9ef99d677e102a7bba535c566dd7471e4288164461a3b4843a/youtube_dl-2020.12.14.tar.gz"
  sha256 "eaa859f15b6897bec21474b7787dc958118c8088e1f24d4ef1d58eab13188958"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "eee698178433fb54ba51d7da64eab72cfad8d615ce03a2317bb06f15862414ce" => :big_sur
    sha256 "000d6053a8cdbcf8544b3de4355ffca75c878c9a72c56de3b3199fed49d44b21" => :catalina
    sha256 "66d2b06edd0dcff34719ebe0ec5138087adff0564756f49d54986b2386bb2b81" => :mojave
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
