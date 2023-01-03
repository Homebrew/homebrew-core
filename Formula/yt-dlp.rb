class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/c9/8d/5701194ffbfecc8af3e0f0af31febc6414e48c0f118958eabfa9ce800abb/yt-dlp-2023.1.2.tar.gz"
  sha256 "b8d7bbb5c1595f718855a31f34d8a0276a7086f5d3f542c021a8ded8b26d36ae"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e3c4c35b06519ee48bd88035b7e39f74bdb79ff1ddac7ea1da16ee1c76b15b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5097ed5e62384f7df163c8e89af7370cdfa5278b9efc2cee166f8c1efbc0dfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2b4150ffbde620572448d9080d2aeeb0360fcf00012430a793c06f7cb290466"
    sha256 cellar: :any_skip_relocation, ventura:        "7b16f655c5951fc78628f90cff000145bcf2327498ecaef0160b1e0d562c14e6"
    sha256 cellar: :any_skip_relocation, monterey:       "90fd348d78316022640cea894bcbebb15325d7ebc18309c2c180227424be37b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e291a26b256f30add584bfe435f5774807d7f7970e17c1eb1efa7f7bfc2bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab98cfb259d29c33d72d7eae1303af2020f56a943d6e4403e485f2121e348a15"
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
    url "https://files.pythonhosted.org/packages/5d/22/575c7dd7c86843e07a791cfa2143e7292d6b380f5a7cce966a49b9d6c9f4/pycryptodomex-3.16.0.tar.gz"
    sha256 "e9ba9d8ed638733c9e95664470b71d624a6def149e2db6cc52c1aca5a6a2df1d"
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
