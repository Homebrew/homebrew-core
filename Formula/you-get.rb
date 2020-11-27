class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1488.tar.gz"
  sha256 "ac486cc3aeadd38b49114705d83f15b35dba6886d73ff446e292ba9e791b8330"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f52a5b35a6e418659fd5ec2de7e9775666b5a621e689cab267a96dccdc4f3a5" => :big_sur
    sha256 "d2ef6bc0140a9016b2bb44a68ab959305d8957be94dc169d203f9fef9f7d9754" => :catalina
    sha256 "b48fc89d82bad1f3d2fb25c8b26a8864830a619d6422a120303a23e4c0aedd32" => :mojave
    sha256 "d6198ab87cd5170f905d8f3fc43f0a15768d9ea2a78949f2dd757ee24de5ddff" => :high_sierra
  end

  depends_on "python@3.9"
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
