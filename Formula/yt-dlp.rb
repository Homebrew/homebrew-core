class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/97/0b/1008dffd196cf6a1f143005b566397f71fb1e767c8e788ea230ae35457b7/yt-dlp-2021.10.22.tar.gz"
  sha256 "a24b9666bd2234149e4da8c4f16bb8e5f746c29428d12ee04fc1c11b5247a307"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9187a631e18557310736035daa113086fd03ee35d9f79064d8f9ce05f6696907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79eacdf05b2540f29a850a101c9b0fe42460d428f96171fc9903e36cd2380aae"
    sha256 cellar: :any_skip_relocation, monterey:       "92cb4f22e1e5979d5da3e7b4527cbb321f8bd70c1791d1d1d08d9d867b7c0fd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "59a10a1bf4752b1f67f17775f4dc5d92c4716288029b00907d37a5267541bb0f"
    sha256 cellar: :any_skip_relocation, catalina:       "d157435a586bc3f19b83f4afeef09dab1c444593317f36a107cb2456035ad3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2d64ea8be899c5b59d480f29e3bebfb9768fd187bd7052d847e04b2e08e966"
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
