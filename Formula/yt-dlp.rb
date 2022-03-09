class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/1b/a9/781ef55dd51d331e3d8ca60723853f13e75be5b8713870c015b3c4283326/yt-dlp-2022.3.8.2.tar.gz"
  sha256 "68546578c18e6ce87450b53769d5d5b7f5a23e5209784976db6c7ccbf7954b21"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04a66663091fff7b60ace9485ccf7ade6b0b601ecd6b96591d715f1482d6a1e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "028a2ffddc30225f1c9ac1a491378c654cbb8b3d61dba66859016a8aa39780b4"
    sha256 cellar: :any_skip_relocation, monterey:       "1f4b9776f84164a0a368b88df92e9fa3becd6f131596aad42b985136a94385e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfe37bd46ddbe9e9cfe70a5acf6b3b96aefa6eacb62e934e27dabef3457ac763"
    sha256 cellar: :any_skip_relocation, catalina:       "39aef10bbcecbf19b282cd48b6d6a3df5a2694476435d169714f1e41eaa5ea3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40f2bb1b7d505a0fbaef1f5dcd2f1086a14b8a3fa70408d69ce0d97b5052232f"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python@3.10"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/24/40/e249ac3845a2333ce50f1bb02299ffb766babdfe80ca9d31e0158ad06afd/pycryptodomex-3.14.1.tar.gz"
    sha256 "2ce76ed0081fd6ac8c74edc75b9d14eca2064173af79843c24fa62573263c1f2"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/b4/7b/0960d02701f783bb052ec69ea32789d878d2cce05a03950adbd75f164758/websockets-10.2.tar.gz"
    sha256 "8351c3c86b08156337b0e4ece0e3c5ec3e01fcd14e8950996832a23c99416098"
  end

  def install
    system "make", "pypi-files" if build.head?
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
