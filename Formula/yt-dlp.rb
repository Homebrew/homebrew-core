class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/40/dd/5a359d561d708edbfe5269c583fd91fd9493a2fce0b77644ffb69219436b/yt-dlp-2022.4.8.tar.gz"
  sha256 "8758d016509d4574b90fbde975aa70adaef71ed5e7a195141588f6d6945205ba"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2041f41dea6a8ac73afccaf0449cdb3383ed9b10b7a8616f7dbfe886c08b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c838b3f4067f1e8b16eea702f2b11c293f0621326f636d48d3f315142fbf9535"
    sha256 cellar: :any_skip_relocation, monterey:       "9c2b7c6aad3c35b9aff1866605c5f27fbb1eb680df89bbe88a47270c7265c1f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd674e28d38cb6f3b4b41a518cdb080d7955daa76afe554eb09daf8904b5399f"
    sha256 cellar: :any_skip_relocation, catalina:       "6fe4fce06c6cc8ecc6a71749e7a29e901a23d21b8c60ec97f856b6ff707244c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e719273d9f1669597470ae44efbdc176348d8a2d8975f77360960e6cc0a9e7"
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
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
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
