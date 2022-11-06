class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/77/e8/b5fd86e2756e2be93c64e90123c0ff31780616f499d97156150327025877/yt-dlp-2022.10.4.tar.gz"
  sha256 "1772a2e6f32b971b4d026deae3044f576b8052035255ca340f345cfe90d38d38"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6dfe5730bdb472344a7b44969da2f46f383f7d49073151564318faeac50b8c"
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

  depends_on "python@3.11"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/52/0d/6cc95a83f6961a1ca041798d222240890af79b381e97eda3b9b538dba16f/pycryptodomex-3.15.0.tar.gz"
    sha256 "7341f1bb2dadb0d1a0047f34c3a58208a92423cdbd3244d998e4b28df5eac0ed"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
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
