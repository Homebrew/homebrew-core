class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.626/you-get-0.4.626.tar.gz"
  sha256 "12143a33711338d5f139f2f4397e94eefe808dfe6b366b745a7993f5145d774f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "fb6aece28013fc8de296ec5e49f224a30ac2f37d0ba8662ba03fa1dcf7669c6d" => :sierra
    sha256 "096718c56e7f6e5bd709b1ef968d14e4c7c8fb38b751d3e01b850f0849f7db93" => :el_capitan
    sha256 "f414366b93592d4a5e9656fe0961e418458aac33e63ca675ade057aa9fdcf940" => :yosemite
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
