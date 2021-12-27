class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/e0/c5/1748e553776f00057fb4b0f648eb22b7e0d58a3c062d2d4a6b8aba72fb4e/yt-dlp-2021.12.27.tar.gz"
  sha256 "2244df3759751487e796b23b67216bee98e70832a3a43c2526b0b0e0bbfbcb5b"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27612d835997a5a06d16f63f0482fc9abde04e0b2eee265a957ab105aa85735f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b089249932e0c466c77bdd7ae19a9df0908477b99c9db2638f34db85689047c"
    sha256 cellar: :any_skip_relocation, monterey:       "278afc5f232d709ced6cc7f450acb297f786a156bfaea844a5a209934696950e"
    sha256 cellar: :any_skip_relocation, big_sur:        "83dc35b247f2fbee6a2b7da4b41478d525df7e465bcb8a53249826eef5317138"
    sha256 cellar: :any_skip_relocation, catalina:       "bd9cce771693c7d69f04b9b7201015ad25b281b95c682700c9831e5e68a6b21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd62c63eacee74fb7b8d989e2b3877ab17bc3bcd7ff68f3a0b306fec2314d081"
  end

  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f6/06/e2ad9e93210790be86d36c6e2d5524ba54928c3ed27dd0be9b2ced7c57f1/pycryptodomex-3.12.0.zip"
    sha256 "922e9dac0166e4617e5c7980d2cff6912a6eb5cb5c13e7ece222438650bd7f66"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/69/77/591bbc51a5ed6a906a7813e60a9627f988f9546513fcf9d250eb31ec8689/websockets-10.1.tar.gz"
    sha256 "181d2b25de5a437b36aefedaf006ecb6fa3aa1328ec0236cdde15f32f9d3ff6d"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
