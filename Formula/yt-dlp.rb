class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/77/e8/b5fd86e2756e2be93c64e90123c0ff31780616f499d97156150327025877/yt-dlp-2022.10.4.tar.gz"
  sha256 "1772a2e6f32b971b4d026deae3044f576b8052035255ca340f345cfe90d38d38"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2549171e878e7e46eaa90ea009f795cf7580852a38b15ab3bb22101ac55b5e8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934cfb31119b9abea80a076c4bbbb24d6c89f2df347b63e39a6ba2192a34b5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe7cdd40c5634ee88de9548cd53c4a1b5470095a207c50a89be38619f257293"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe164f5cd9c28dfc6e33a248c64318eccd3c4eda5a2b281f7841ed899500944"
    sha256 cellar: :any_skip_relocation, catalina:       "021fa5d6785b4ac41e287d2f7307cc8446edb9aae027f5b33f8b3aa5b31e63db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a11bb9423a2a9b42f1c21e9960a249f8884ca2209ce0dcd4aa4f81db32be1bc"
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

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/52/0d/6cc95a83f6961a1ca041798d222240890af79b381e97eda3b9b538dba16f/pycryptodomex-3.15.0.tar.gz"
    sha256 "7341f1bb2dadb0d1a0047f34c3a58208a92423cdbd3244d998e4b28df5eac0ed"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f8/a3/622d9acbfb9a71144b5d7609906bc648c62e3ca5fdbb1c8cca222949d82c/websockets-10.3.tar.gz"
    sha256 "fc06cc8073c8e87072138ba1e431300e2d408f054b27047d047b549455066ff4"
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
