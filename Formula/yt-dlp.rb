class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/e3/59/d367213d96c63c98c9f23140da8ec6f610a48cd9cfe2a740d0b17df120e6/yt-dlp-2022.1.21.tar.gz"
  sha256 "220ec407389b5ea72e25dfc11c30e543489b90075c55311d5255e2045db8a9e2"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14d46451bce113bac75d70f87a430c3a65db723787165ce7938c7ba33a2080c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06db248c91cbee980afd2bc75b4a9a6f17f478ff1ff4b47e7aa2ac7fc95e0ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "99f715982ea1dee9ce029da20c032d87fc831ad33b2817ab033d4c2ec973cb92"
    sha256 cellar: :any_skip_relocation, big_sur:        "7143a6ff68308f0229d97c2926dff9aada74abe0a9af076132241cbb2c745440"
    sha256 cellar: :any_skip_relocation, catalina:       "8f054ff978c40d57096d1a696d9b78a302e2237bf161ede23569e1a9140cfc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026176b876c6de100931badda54c4790cca7ba9031512f499fdf4eaece179dae"
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
