class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.652/you-get-0.4.652.tar.gz"
  sha256 "60e094e02c6786cca73e161ce021a07b35872195c7562e7bada8334f51fa332f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "6a8d6681066b6f3cc6e0ca001763e746c8df6d89c0466069d98123fba98c0d4f" => :sierra
    sha256 "3788ee1f03bcf7278bc3140086f39643cf4fe33e5e88b722d67b664df3ce0f0a" => :el_capitan
    sha256 "338c662002255ebbca86f3ba4ec38cdcd074e20365c6d73bf45028eacdcd9730" => :yosemite
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
