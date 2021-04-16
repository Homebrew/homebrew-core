class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/14/0c/c2ffe08208f9a9c428850c3df2b13079c7e49a1b09cb2fafce5b87c9b32c/youtube_dl-2021.4.7.tar.gz"
  sha256 "34a034d9b2062e428710d4cd6365db7a64cd388e51a3f9ab74058179c95d8654"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "230e90fdbe3cb80760936a7cc4b82fa9652ca5799bcee66d22aa2936447d7824"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfc47da4853b4fa2db047b34270718832e38eb02e35fa644adaf04cf7fccc321"
    sha256 cellar: :any_skip_relocation, catalina:      "8ae1f30d4abbbd77edfa98883f7cbbb463662b49c68acc52441cc3de4db90909"
    sha256 cellar: :any_skip_relocation, mojave:        "33bc1b43eec130aaa49c05c5436e46148fde418c7c733cd149a9d10da369180b"
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
