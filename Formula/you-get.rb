class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/ba/16/9c3660c4244915284cd7ce1f7ba3304cec29bdf3ef875279b3166630f6be/you-get-0.4.1620.tar.gz"
  sha256 "c020da4fd373d59892b2a1705f53d71eae9017a7e32d123dc30bef5b172660e6"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bb623904f604ad1728a54e7f6a1729c728cb0b21aeb414d472012824f88adc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47bb623904f604ad1728a54e7f6a1729c728cb0b21aeb414d472012824f88adc"
    sha256 cellar: :any_skip_relocation, monterey:       "69bd3721351cfd339187988f5c3a8166669036d157e3f8da86667d022fc0b231"
    sha256 cellar: :any_skip_relocation, big_sur:        "69bd3721351cfd339187988f5c3a8166669036d157e3f8da86667d022fc0b231"
    sha256 cellar: :any_skip_relocation, catalina:       "69bd3721351cfd339187988f5c3a8166669036d157e3f8da86667d022fc0b231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbae6a331481acb19ae10d89b9d2423f94747fe41f822d0e556027247d038422"
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
