class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/ad/2a/19788cdbce56ea05600068bf342f91c91fd5acc6c6486e16d498b0ec533a/yt-dlp-2021.9.25.tar.gz"
  sha256 "e7b8dd0ee9498abbd80eb38d9753696d6ca3d02f64980322ab3bf39ba1bc31ee"
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
