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
    sha256 "58831026cf9e75bf6e64593b5801575fa6813bc5f467128c58cf5567f7a93593" => :catalina
    sha256 "00c0171d2bb859189e776bd49533d904680858a7584f9135bc4af2db69f61453" => :mojave
    sha256 "99542b4f6a4e32e3d63319935b74f273f8fb1ed995fa03bd1ccb39d0430c8341" => :high_sierra
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
