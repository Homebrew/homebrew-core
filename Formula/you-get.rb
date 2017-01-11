class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.626/you-get-0.4.626.tar.gz"
  sha256 "12143a33711338d5f139f2f4397e94eefe808dfe6b366b745a7993f5145d774f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "188e0a177a10439ef44a39a51335683cd863bbc03a710e2cf334b7edb18bb66c" => :sierra
    sha256 "a621cf943da03bf4353b7450a6b2ae6e12adcab3e2d6ca9ae601683b32fc85e1" => :el_capitan
    sha256 "9a14ec6e3f4cbbc16a5ce0b8e537ab05ee6b200c5792cde82e23d147182903eb" => :yosemite
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
