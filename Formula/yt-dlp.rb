class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/5c/e0/e5bae3e87ee6da0f7507f3b58c5e9ffc1500de0742886ccc72c1a56740f2/yt-dlp-2022.2.4.tar.gz"
  sha256 "81b50ed7cf9cfcc042d8f5a1ad2d1cd7b13c48b36c07faf1880696eac0a7ddb5"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d16a14de60e3dc3b610e0fedb8b2b9eabbb3c4ce4a2bc7c1c728daee6ab717f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e8a9626b25b82baa83928a64926555431981c439addf16f5b0fd14254fd04a2"
    sha256 cellar: :any_skip_relocation, monterey:       "785df7e0744a4fb1284948fdedcb9af27c74b1616421015fa77e6d59fb512be6"
    sha256 cellar: :any_skip_relocation, big_sur:        "44fc5ba12c49068cb204ad242f0fa955b19b8f7d11cdb786a401c65bcec43b89"
    sha256 cellar: :any_skip_relocation, catalina:       "90886a79d2e7f8b50bd095f6b7ecdb70e01312862adc09d1f3d16b6705a42c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a117315f80b7955a5775c6b2d7149869d650a8bfe07e097c1809b9a8a698901d"
  end

  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/a6/b3/a5e59cd3ad65d4dc470a3a63381d0495885cf1ac7659c83c6bc9e9e79df6/pycryptodomex-3.14.0.tar.gz"
    sha256 "2d8bda8f949b79b78b293706aa7fc1e5c171c62661252bfdd5d12c70acd03282"
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
