class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/5c/e0/e5bae3e87ee6da0f7507f3b58c5e9ffc1500de0742886ccc72c1a56740f2/yt-dlp-2022.2.4.tar.gz"
  sha256 "81b50ed7cf9cfcc042d8f5a1ad2d1cd7b13c48b36c07faf1880696eac0a7ddb5"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca50f2157bec68534c4f4188e6398830a7c2a73dbf5ed78e579760f1197d8704"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f0ac91b719b7dce2489169393c65c764af5a5c1f7e28fcdf51b408501655995"
    sha256 cellar: :any_skip_relocation, monterey:       "24b775f99c550fd3ae4c408c735bee97368ab3b26ab9572ed134175b1cc27d95"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1090c7956a99aaf339272465dc9605855cf0adb0a54daceac0af7e6baab5c40"
    sha256 cellar: :any_skip_relocation, catalina:       "7c87b4e0cf50dc631b8b3460c54a2ff1f22821408b7373c894c7a84846ee827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0dd20f1e980a2d05a85e586e11be0c62780623caa96670b0b2c16969953f23"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
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
