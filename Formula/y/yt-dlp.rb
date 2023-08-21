class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/db/c5/e08a7aa42c962d34201151fa6b825fed7fbb998a1b612f37c7eb93a7e764/yt-dlp-2023.7.6.tar.gz"
  sha256 "cb58373869c8ccb5034746f91cfccd6d25ea697090dfd6f93e9034d51eb4aed2"
  license "Unlicense"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af529d4305815e86d0d27431a59e6e64fdc7cda31cbc6b7c16f4c1f111aed28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a89b18f3fe6452c24217fed43bec9abfb4d4ea1f9de4fa44ebcc8c28732fb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0045eefa4f8b63308dcc9684da91b6effd60aa3528e56a28a8b5cb9e929baa94"
    sha256 cellar: :any_skip_relocation, ventura:        "37f3696765f471d5325c780a9823d45177412c7ea2c5c3077fad7f38a7a09430"
    sha256 cellar: :any_skip_relocation, monterey:       "4a246654ec69866a6fb04e05ab24d45543332cb1b71f3721504f67205c2c4202"
    sha256 cellar: :any_skip_relocation, big_sur:        "94937c92c0ba7f1fec7c5bedc07880b4c1fc1dd98bca43aa1833f2b5b56a89a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc41d23380525ee80f42c29ab3cc56784b1d207daacd88ba11cdcaae9138dcb"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/40/92/efd675dba957315d705f792b28d900bddc36f39252f6713961b4221ee9af/pycryptodomex-3.18.0.tar.gz"
    sha256 "3e3ecb5fe979e7c1bb0027e518340acf7ee60415d79295e5251d13c68dde576e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
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
