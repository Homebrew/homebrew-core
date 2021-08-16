class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/3d/e0/df190bb3752f6e2f287e07178e6ff0ff8cb0c1f55f5c5fa46435f12bbc61/you-get-0.4.1545.tar.gz"
  sha256 "63e9b0527424c565303fe3d8ede1cd35d48a4ecf4afe72e1c12b0e90b9fdcd39"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6574d777066ea14a49addf18a3c4e140e0418661924f4f5be114773774dbf5fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "705131867a8133378007676f4dd32e48f81604c06e2f45f1913d18c027730400"
    sha256 cellar: :any_skip_relocation, catalina:      "705131867a8133378007676f4dd32e48f81604c06e2f45f1913d18c027730400"
    sha256 cellar: :any_skip_relocation, mojave:        "705131867a8133378007676f4dd32e48f81604c06e2f45f1913d18c027730400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f334ada5d5ee92a53bd314ffc0d911cf408c869585bec064c1a656851a83a7a6"
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
