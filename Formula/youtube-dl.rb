class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/14/3a/06995d7ed6afacbe859af38b3c623e57dc6135d806bfd334695b30d997e0/youtube_dl-2021.1.3.tar.gz"
  sha256 "67cc185783ef828249bcc199317a207d19e1320857bb16e68d64ea97ad2793b3"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "17996d3eb68214578340e389340f40ce00c4f48263d160fa6cc6302e3b5d3145" => :big_sur
    sha256 "44650dec017b1d3729bccac21a41ae0eefc32092083de5e64bf886566933dd5a" => :arm64_big_sur
    sha256 "8d258573cddaa987f7422e06fd7aa4f2c05b213616f265e559a8262c20adc1a1" => :catalina
    sha256 "0f8e413d475812290e4abb16565abc89cb3a16bc44e0961c85bc11a1d9505fc7" => :mojave
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
