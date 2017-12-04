class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.995/you-get-0.4.995.tar.gz"
  sha256 "920e1769711c2b31d1aafa56f520aa040b5c81074c60e7c427e25d1c7177a862"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cd036e24e9104e13a04aeaf5ba0c1fe38d6a53e9f56b489c5862cd6498fbf3d" => :high_sierra
    sha256 "ae91870c0c3e102e94e3767f45ea3797dda3a0d9bc1be732832632a5150cc2c6" => :sierra
    sha256 "3798037a8cd11bdc6bc24c59d84f38580af3260c994c23ad39fa144d1a035d56" => :el_capitan
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
