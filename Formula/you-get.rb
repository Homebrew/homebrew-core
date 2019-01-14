class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1193.tar.gz"
  sha256 "74046ba4994630db7f66145f318d76c5c7bc8802a42b8c6e393909b1c86326e8"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aeefd7b5ecf629880ca3a751573cf413e766daa773543a4242773f20c9144ee" => :mojave
    sha256 "46307345a7c375192c370f1b52ca1909fd40a990eb1fa4a0c03784b0ffc4ac20" => :high_sierra
    sha256 "27c66dbbe2f8b5d4d3210068e1f36847bff7cf9db320380bf88dcfc547ff1f63" => :sierra
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
