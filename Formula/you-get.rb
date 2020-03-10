class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1410.tar.gz"
  sha256 "59aa94a045518b39ae24ad5d24fd7bc9d01246aa87d20178eb9f38e49214c03f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "69d504f3eca3f7b7892da9d8624d92a56b4f647a92141bf2dcb7bb11d4be490f" => :catalina
    sha256 "7d7dec77b67db738da8a625c354834a4ee79bc097c1c7f9156cdef92550eca6b" => :mojave
    sha256 "52642a70d4ed428938790e6c4df75f2020c4fdca6d5d34da2be074d951722056" => :high_sierra
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
