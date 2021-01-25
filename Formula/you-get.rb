class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/b3/eb/e24fa3352fa27e1be3b7f8b3d158a3b12f6ee294c09614eb61b5d85fa054/you-get-0.4.1500.tar.gz"
  sha256 "5a6cc0d661fe0cd4210bf467d6c89afd8611609e402690254722c1415736da92"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6264f3509de8eed9b86952c9e29ad83c701f829af203e6cf15ce7fe5a783309c" => :big_sur
    sha256 "2238c1f593a3d1e05642f550d5fd8b95bc871efc8fbbf8ca84c62b7838c8fb9f" => :arm64_big_sur
    sha256 "0ac325b9b2db370b23fd3c402cae58ae94c4df8ab590612af316c35c2ffb9f2c" => :catalina
    sha256 "42900e74c53614573349195e1761f60e7e9fa696de56ee79acc17d148c4de93f" => :mojave
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
