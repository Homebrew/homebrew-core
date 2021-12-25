class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/cf/8d/55cd397fcba29bbf7fce474d9a6caeeba842a868d274baface65117317d9/yt-dlp-2021.12.25.tar.gz"
  sha256 "87c13517c55510cfaca8617260de376029035dbc2f8715a7426ba5652e8fe212"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69408bad5b7f35ec78a335f347ab3be41cbd7408e2154329a748fd87dc1c8310"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6872a9ef7ff7db8f767179219beee1ba3f6ca8eb571c6d292537b515c9873347"
    sha256 cellar: :any_skip_relocation, monterey:       "8a50f19f3b0ab2344d45a31da3f81ebac9fc2ca444b951b22fd3a1f65fe0932f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecfddf179e2ebe7c9dab1f5e4809adaf949cf08b7b11acaeca6717f08bf831ff"
    sha256 cellar: :any_skip_relocation, catalina:       "da143959717321bf0804b4f2715d3ba9cf03d4da29bc43d83b7a2bca12652b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d544645f452df15db2019b847fddccb74abd488b292e8b3b7ce1bc3112ca8c51"
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
