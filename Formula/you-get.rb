class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1355.tar.gz"
  sha256 "5e45c92de6d1ad2f5dd0a7491af6a695910cf72ca82b2c3ed0ce2520e6daabd8"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e1051bc16a923d7fff256a1b998d0f2ec8c7d2a3232b6ab2723de60e3fa9217" => :catalina
    sha256 "085cce1c4615c7b288dc1ff076bc30034684c1156317fc88e1157dae33aafabf" => :mojave
    sha256 "24799a91b82cfbfcb7aa15a2a1e95cf46c89eb00b48b0f37581dec5afd417bb3" => :high_sierra
  end

  depends_on "python"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
