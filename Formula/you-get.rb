class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.909/you-get-0.4.909.tar.gz"
  sha256 "abdd89afc5d2b3f20c6d7d52b63e840fc3c468f3c0950b480486e9877bdce210"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2f1dddfe0087bcb586aa06de6523e4ccffe377fe9af6dbd061fba9ac3bc4b08" => :sierra
    sha256 "9acfcf669ec2222ecfeee2a25897f357eb659a287b98f85d5b9913d5b60b2118" => :el_capitan
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
