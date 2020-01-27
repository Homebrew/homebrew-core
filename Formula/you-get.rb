class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1403.tar.gz"
  sha256 "1d5a46c273418ee971cb44a9e4b6060c1d9488b88692740c3ed6dc7669686c13"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc2847209e2df0392971ca3f8eb1eb3568727194d4f9abd54fc1c4dfd069b912" => :catalina
    sha256 "b5c4b692026ed50964e32123dcc7f0ca547bf1c9fa3fcaaa8c313c5d051a21d8" => :mojave
    sha256 "eea0ffa9a11dc449b37923ae91e17aff88350fd859dd3f0fa357cd677bbbdb13" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

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
