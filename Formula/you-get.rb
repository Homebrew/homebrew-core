class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/01/65/3830393a7abb7f744fd2a85324859aa67d9979a4fa0cbdba4d2ec192d038/you-get-0.4.555.tar.gz"
  sha256 "a90f26c8059240803b1c0a9ed9816af3f1831b9d8ffb9be572a0f5fb4f6eee4d"
  revision 1

  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "bc8d8a659f9b66766f0ae3243bd9bdc64f023a9ea808db7c7c57e6a9c9fff8e9" => :sierra
    sha256 "7a4c700cb5a19050bff936a8d248027e8c23088de1a0f05134e290cb7a7ba691" => :el_capitan
    sha256 "1b64f6b1746b12ec741bd26ee5fc905f7ae2f367ddf22f1f6893f131a13d03f9" => :yosemite
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
