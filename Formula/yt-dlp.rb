class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/76/de/7eda54327dae4d7e917e02a1e49c4fd343e59a7ce4ae259df96f2cc7b4ea/yt-dlp-2021.11.10.1.tar.gz"
  sha256 "f0ad6ae2e2838b608df2fd125f2a777a7ad832d3e757ee6d4583b84b21e44388"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d11e78f9b3009179f39c635124f848b473deb08e6c44c375af59dabf771cae3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43b8468cfc88c513a482aef8940ec113f03a282dcb9924e0d91e7386571fb68f"
    sha256 cellar: :any_skip_relocation, monterey:       "69ef6c2590488a0c16858692a35bbabc65c1b13f4f009464444000b6f5e5dd1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4055439bd4716b8d10fb165271fab485855fb339cec3063c110db2de6abc98d6"
    sha256 cellar: :any_skip_relocation, catalina:       "6e48ac9113e974d9079f0508237fb10b0e7f4ff66b99cf6e54f34c2bf924dd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ae9ae3f6148aa234b5fe5021acd461005c488f1f3d7429c04b6a481a7651cb"
  end

  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/47/14/dd9ad29cd29ea4cc521286f2cb401ca7ac6fd5db0791c5e9bacaf2c9ac78/pycryptodomex-3.11.0.tar.gz"
    sha256 "0398366656bb55ebdb1d1d493a7175fc48ade449283086db254ac44c7d318d6d"
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
