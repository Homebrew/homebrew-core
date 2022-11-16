class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/5c/5e/8bb969d9063324267de01d1bdf5daba2f96659a13e0b443bb86b45d72a24/yt-dlp-2022.11.11.tar.gz"
  sha256 "f6b962023c17a77151476f0f6ed71be87d017629ba5d9994528bc548521191b6"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0c5a10a284e7153f8956da75a7a6c0058eb97ce7c753b107611589a41c9151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e526a3e2ae16a7c0f4dcab7d8c50f48753a9518a7c771178bc68a641436491fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f729eb77abb69b6bcc8c08a2ea10889bd22255c86f523c28826641d5538d24ad"
    sha256 cellar: :any_skip_relocation, ventura:        "04994185658bd396c45eba0aae4ebeea7d416832c23908540576bc1dc791c1f7"
    sha256 cellar: :any_skip_relocation, monterey:       "ed6b8cb4771f36b5afe3c2f5eb905d206a64c2dcee0a14930a25390b6c5b455a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e8e58f381d18c7ae706e17a495c7809d26b92f59beed3c7a1dfd8239094ea01"
    sha256 cellar: :any_skip_relocation, catalina:       "dab77e4d1b4d4b88c4fb0915336cf2ad738984ecab2b314b82894abde4a48f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f413e4af9713c05a157a275d3f55591a7a60591c5ba34e1c4f591b69b6877e1"
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
