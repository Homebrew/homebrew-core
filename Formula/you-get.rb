class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1099/you-get-0.4.1099.tar.gz"
  sha256 "331e43185e309d13943de2aeafc2c19cbe2f2af67a46f920106bbd2d76873ffd"
  revision 1
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a8e8acc3f339e45371b31e963aa3d4bc340d584c8910928aaa7e41588a05adb" => :high_sierra
    sha256 "61447e2d6bd8ba84975361ac5289ae294a46a0a8c661e6e8f82e5d739cedc1ea" => :sierra
    sha256 "8f094f830a584a99d86eeaee012e1a49bd147c88789caa4a2850c2ea3a7e535d" => :el_capitan
  end

  depends_on "python"

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
