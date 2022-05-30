class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/c9/87/0ad2082c87762cb7dee763f2982c02f659197b28417577191873054add20/you-get-0.4.1612.tar.gz"
  sha256 "94a133b70c27d699c02eec03880d4893df97095c8ef943286effa15eed269f9c"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d0e6952e12ecfccc70ddf701ca4514bdc63f7691cd4bfccded7368b4d87295e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0e6952e12ecfccc70ddf701ca4514bdc63f7691cd4bfccded7368b4d87295e"
    sha256 cellar: :any_skip_relocation, monterey:       "5eab149f5f6790038d34c8549ffaac5a165b745895c37c46f759e05390196566"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eab149f5f6790038d34c8549ffaac5a165b745895c37c46f759e05390196566"
    sha256 cellar: :any_skip_relocation, catalina:       "5eab149f5f6790038d34c8549ffaac5a165b745895c37c46f759e05390196566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae49966f9bb2a9504c724e27206bce06925e950db0f60f18b2c67a8f4a96e4fc"
  end

  depends_on "python@3.10"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
