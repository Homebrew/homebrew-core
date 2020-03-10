class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1410.tar.gz"
  sha256 "59aa94a045518b39ae24ad5d24fd7bc9d01246aa87d20178eb9f38e49214c03f"
  revision 1
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dacfac03f1b0af5b35777d90b7250e893bcfc5d0fa4fd205c837c5af061fc9e" => :catalina
    sha256 "8092347a7b929f69f27b918164651bc55fa86f515ac629cd315c23d9fe5cc1f1" => :mojave
    sha256 "101fbc6ddbf613e1d690e383143ced8260b6d308dae646e9880a8da121e1c7b1" => :high_sierra
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
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
