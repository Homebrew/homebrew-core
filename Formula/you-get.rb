class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1456.tar.gz"
  sha256 "619e2f5ae4b801dc196a2fe75d518cedd2f9e811db0fde7433de645a97898318"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d5a16c6314054c05933c863ea5d7ac86d92bf599f5a40f3289a9e9442622eef" => :catalina
    sha256 "968398ab3aadb8102966e73b68d27df1e83393d221ef7434bf89eef78fc7b30b" => :mojave
    sha256 "95e8eb0367df79f532e351c44a1eb7e710f5c26af769e2065dd09dd8399c3489" => :high_sierra
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
