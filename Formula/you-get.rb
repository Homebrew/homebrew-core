class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.595/you-get-0.4.595.tar.gz"
  sha256 "c366ccfa14e334fe9320b52582a4a41c5d396181fadc5d82eb2dda1f7f5d2a70"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "0a0b5c01adc42f688f424c1d5bdfcfdc2a025bc1da1ecc627eb49b72314d5b6c" => :sierra
    sha256 "50ddae01f736a2f9a7a7efa2c15bacd413bea2b130d964942d766f6cfd6e2527" => :el_capitan
    sha256 "2c1b9c84ece8021a37668fff3bf4cdf9f8cec134f8a348768f083130558d4db2" => :yosemite
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
