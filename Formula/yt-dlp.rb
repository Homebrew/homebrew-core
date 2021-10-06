class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/ad/2a/19788cdbce56ea05600068bf342f91c91fd5acc6c6486e16d498b0ec533a/yt-dlp-2021.9.25.tar.gz"
  sha256 "e7b8dd0ee9498abbd80eb38d9753696d6ca3d02f64980322ab3bf39ba1bc31ee"
  license "Unlicense"
  revision 1
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25e405c758fbe4187075ebe5e17af269c8077c3f15efe615e96d0c6fea8d0007"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c67837094c26d0d17839c365577c1efeb930175bc62bae27760c2a52ee41fc9"
    sha256 cellar: :any_skip_relocation, catalina:      "1ae46e9b0ee92613a9011fb355bb1fd54296976315b6b13f5330dff76fc33ba1"
    sha256 cellar: :any_skip_relocation, mojave:        "084ed12bbafaffe3f32229a86de2462dbf54b14465df0803860dd33358444cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b520ba19435e8a4d00aadc232c06b03def95fc8f630a471c1ccb02cb270bcf"
  end

  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/f8/8e/14a8238190bcf1bab3d58432cd795c859edbc2f5abd8460f80438046a799/pycryptodome-3.10.4.tar.gz"
    sha256 "40083b0d7f277452c7f2dd4841801f058cc12a74c219ee4110d65774c6a58bef"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/1c/f4/61aee1eb4baadf8477fb7f3bc6b04a50fe683ef8ad2f60282806821e4b3b/websockets-10.0.tar.gz"
    sha256 "c4fc9a1d242317892590abe5b61a9127f1a61740477bfb121743f290b8054002"
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
