class YoutubeDlc < Formula
  include Language::Python::Virtualenv

  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://files.pythonhosted.org/packages/1b/12/315fc9d4d619dbe2328b8805a25c26590dc06a0fed276385d89e44ab4e4b/youtube_dlc-2020.11.11.post3.tar.gz"
  sha256 "5aaa0aa5fbd53d9acdfa95bab3c26802926eb27e425f23dc83d55cb18f11d053"
  license "Unlicense"
  revision 1
  head "https://github.com/blackjack4494/yt-dlc.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00c731f3aa0cac636ee980b19720eab0bf8e3fe19da5751addc8997bc491af08"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5b0155e1929150e4a35fc02513fc105d25e03fe778edd6db94302d9c50dcdd3"
    sha256 cellar: :any_skip_relocation, catalina:      "d18e35ee7120d9d76932338981585f68f42ff16ef91268d02ef58de4fb9f5c42"
    sha256 cellar: :any_skip_relocation, mojave:        "044a2108153ef9ce3e4e5e7b3e6602c5789ab6f4449511050dbdc4a805e6077e"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dlc.1"
    bash_completion.install libexec/"share/bash-completion/completions/youtube-dlc"
    zsh_completion.install libexec/"share/zsh/site-functions/_youtube-dlc"
    fish_completion.install libexec/"share/fish/vendor_completions.d/youtube-dlc.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/youtube-dlc", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/youtube-dlc", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
