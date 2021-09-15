class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/10/4b/7ac9cced452f67f3d75ea460eb07c8dd377b8cc60337b6ae465e38f6b2d7/yt-dlp-2021.9.2.tar.gz"
  sha256 "ca7e77cdb055ba2683df5b0807aab1c1e120cbe02c8f35d9d3293d94dbdaea63"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59026142e9d7c1187b451f23ecb1ba715454b8cf3378f01f664a21a3e2c9bf01"
    sha256 cellar: :any_skip_relocation, big_sur:       "a61a7e4cc74d5ee38d0c9b2e72e5f175c0eb870de824dc530306d243fe411f2b"
    sha256 cellar: :any_skip_relocation, catalina:      "63e21a735a7b36f3ca2feb944e363d127a2cfd77f6326598f2d0b45dc49c0437"
    sha256 cellar: :any_skip_relocation, mojave:        "ef73eec44092d6a1477c481f8c4f9a29ac045d8cf51763e4bdb3171c7b6df688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ac6353a780d7a77e2ecb7115f2101383add56dce294c3b60d26bf89f24c65a"
  end

  depends_on "python@3.9"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/0d/bd/5262054455ab2067e51de331bfbc53a1dfa9071af7c424cf7c0793c4349a/websockets-9.1.tar.gz"
    sha256 "276d2339ebf0df4f45df453923ebd2270b87900eda5dfd4a6b0cfa15f82111c3"
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
