class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/30/70/578521a22783112ae3dc01e33b23429151edeecb585c7b1ed58feee7fef3/yt-dlp-2023.2.17.tar.gz"
  sha256 "9af92de5effc193bdb51216d9ebf28874d96180d202fae752b0d9f2a63380f3a"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "414b129dbc5ba8c905c1f373c875dee7a6334f867ebc0182207c46f45803226d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0afddc6ed78cc1ef4f4633562bac5158282b4c95d4bd5597b56e48945e8e50fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962362e5319f49b4fddf969c2e0c5151a7e95990734c0e74655dfc4e801979b5"
    sha256 cellar: :any_skip_relocation, ventura:        "bc72bfcc9e321dc62b334d85eb6862dc0ce3650a9916e1f00022cdf4434cd47f"
    sha256 cellar: :any_skip_relocation, monterey:       "84cc8095be4b8e07eb01a78231359c1b79f9779bb097c0b7ed10d8829185a69e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17d741f6af8fed1c762222ea81e642fb34dc8529c6c7e428f72387efc55c0688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2fc58f22f8adf6852b9f5c0d9fec1962967f0d8bbcf21b2c9db4f4c2017240a"
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
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/3d/07/cfd8f52b9068877801317d26dc7225e19421bc659e1395d2cd6933b1a351/pycryptodomex-3.17.tar.gz"
    sha256 "0af93aad8d62e810247beedef0261c148790c52f3cd33643791cc6396dd217c1"
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
