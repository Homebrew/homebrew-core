class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.990/you-get-0.4.990.tar.gz"
  sha256 "16f6d233946993f46b7af4abf4233cde21aa182113e089e831318757b790dc21"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a89539ec2072d27bc6892ab7b00cabc4ed1f35769ea8e535b4cbe44dd4276b2" => :high_sierra
    sha256 "3673d9d1bbf8198487394c4d65154d142bfa0faf499b3b8da54b4185d3550b1a" => :sierra
    sha256 "9f54e7e684563f78004d1c92cfdb2b10f4c631dc6544aefebfa8546ad3905e38" => :el_capitan
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
