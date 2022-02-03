class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/d8/6f/e7f7918b29bb3a4da8d1f548a8a3c5e8446acb02fb4bcb1254a225a9c407/yt-dlp-2022.2.3.tar.gz"
  sha256 "955dd1814abd178baff2383d1542efee48adfc9de9e2f5c86784b09cd6f5a262"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d22a2aa199f654ccdc53565bb68fd2305775e9b83608a69cec009856b06c1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7681c56bad9358094e39a190d191c5048fdd9568ff45ff0e51375ce62fa6079"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1dafdac2dcd513042ed7be7025f01fccc8bf6d74963d343184557e7a4825d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5bc19c485a87923ae03c361024af4234c112a5bd119d7f703b116c2b7bc50df"
    sha256 cellar: :any_skip_relocation, catalina:       "47232343e9aea8c05ea6d9e164c25c48beb3aef480e72e782fb51197a1c8de43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0bf4f057ac16ede29d166bc29923df1780643bcde75e34b43edc07b275d007"
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
