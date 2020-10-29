class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1475.tar.gz"
  sha256 "77928e28a93aca13f56ca32a977d793008a7a29930e85c75737366da708af877"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "03991ef157eda89095259ef011126055daee0dd8bccb145ed6316491b40eac81" => :catalina
    sha256 "acb62c00f7b539e3ff5e257917300838325705ec92313f64480a1ec20e7ee545" => :mojave
    sha256 "8048403de4fb1938428bae676b84955f0f7ffbc03bc3c0465483c076865d792d" => :high_sierra
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
