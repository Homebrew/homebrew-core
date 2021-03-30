class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/83/f5/fe13c4859e9f7007fd995ecf6a05b85237c879323d070d54d9815f8e0e15/you-get-0.4.1520.tar.gz"
  sha256 "890be0c9637ae571bf5ead8015c4fe1e75de8adeae3aece545a1c4aeb8282fab"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2238c1f593a3d1e05642f550d5fd8b95bc871efc8fbbf8ca84c62b7838c8fb9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6264f3509de8eed9b86952c9e29ad83c701f829af203e6cf15ce7fe5a783309c"
    sha256 cellar: :any_skip_relocation, catalina:      "0ac325b9b2db370b23fd3c402cae58ae94c4df8ab590612af316c35c2ffb9f2c"
    sha256 cellar: :any_skip_relocation, mojave:        "42900e74c53614573349195e1761f60e7e9fa696de56ee79acc17d148c4de93f"
  end

  depends_on "python@3.9"
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
