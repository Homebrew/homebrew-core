class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1302.tar.gz"
  sha256 "ad48509867c4c5833319e3459530c87991a1f174541d850fffacee7a1573e124"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a54a7ff078de174f7e8623d303f28d13c05b850f95e2c896d0044665b0f68611" => :mojave
    sha256 "a2ef7d9d09a9ff9addcf2408e44e25214b1827c8b11fad0c3ff9d64a642cf960" => :high_sierra
    sha256 "0300d9d29539389791977b7ad9c3fe91e56c7b0f299669b19762454703e175f8" => :sierra
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
