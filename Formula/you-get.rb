class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.995/you-get-0.4.995.tar.gz"
  sha256 "920e1769711c2b31d1aafa56f520aa040b5c81074c60e7c427e25d1c7177a862"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "12c05f19f094b110dcae0163ba0703371698e16943400c4d4d0f7796f7858a71" => :high_sierra
    sha256 "ca03939cf122febafb30e8d583a5e4004aa0609a980171fb42c7c0a7e29559e5" => :sierra
    sha256 "295820a3ab7275fae54c96a876dfce978a5d31d66bd95e21477927f2d18c63ef" => :el_capitan
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

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
