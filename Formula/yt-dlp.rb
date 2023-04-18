class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/e8/4a/1e01f24fcb49191626e2b17d00e13a093315d03a9da09fccb1c75913e420/yt-dlp-2023.3.4.tar.gz"
  sha256 "265d5da97a76c15d7d9a4088a67b78acd5dcf6f8cfd8257c52f581ff996ff515"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a0e990cd6d8e33ed7abcde743b0c121705656315f724b4b4e83ab9976da28bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25240328295fbb5bdb9bb086af1471b71faaabfea54ea403f1b576af9c17df7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a2c79978a05d73831c240ec82b96a99b2a6480ca7276fcc2f7ceff45fa74a2"
    sha256 cellar: :any_skip_relocation, ventura:        "fcdc5c7a4aa821cd8712eb3745e93b887741c56208b7f4a1ab4886d3a3c1bd19"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a404c9dfa604bd45d9cebf09819892d0fcaeb0629064ddf4ba56a5aac9184a"
    sha256 cellar: :any_skip_relocation, big_sur:        "16a7b619b2b0e0512ac7246a881479f092a9d70facefd42dd32bb65fa96aa585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e60629a7a90a3c0cbb097b86c49d231ee8955efb24f1696a275e2ab4833034f3"
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
