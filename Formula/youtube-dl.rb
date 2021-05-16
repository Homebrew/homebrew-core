class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/12/67/a37eb6231ff26b4a4bc7cee2568d44e11ffeddb84a9b0798869a4392f3ce/youtube_dl-2021.5.16.tar.gz"
  sha256 "4e569cb0477428fd96ee6f7e7a6640b7c9416be626ed708ac4b8ada6c5a6ffbe"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f7157a62d4e169f6ecc7c5ad37673af375a0a25fb98a18b78df14e8bfc9e9e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe22dc27cbe5eaf6989f7370c20efe6acac971cef923cf682331cb11f7d13b88"
    sha256 cellar: :any_skip_relocation, catalina:      "fe22dc27cbe5eaf6989f7370c20efe6acac971cef923cf682331cb11f7d13b88"
    sha256 cellar: :any_skip_relocation, mojave:        "fe22dc27cbe5eaf6989f7370c20efe6acac971cef923cf682331cb11f7d13b88"
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
