class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/83/c3/30c12eab2c20dcb8609be38d235a21990228446f0dea2a1d5afc8b1a5d9a/yt-dlp-2021.10.10.tar.gz"
  sha256 "cc96211e8e55ebbb48d2e6609c0d0942507eb5471b2ce74e38f7b95f8d70a4e7"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef335c9197c622cd83af07eb3bd104825c954204183c7a3d32b69b15c577de33"
    sha256 cellar: :any_skip_relocation, big_sur:       "969caabe6681c7ce08a356a9d67db7bb1ac19a54dae806cd039512eca31c8c31"
    sha256 cellar: :any_skip_relocation, catalina:      "7849aa7938120dbfcdae1e8672fd2e9e597852d6bb76f7c06992a8a3d6fa3119"
    sha256 cellar: :any_skip_relocation, mojave:        "625ad2e6f9b220e14d8215c9f76f7cf313c0b58549bd9d7cb2e427ea9c031691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5f4e3cd4ec68a7ed436f8912a713be0e893615d4306ede44e8b8b3aeb81ce0"
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
