class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/01/65/3830393a7abb7f744fd2a85324859aa67d9979a4fa0cbdba4d2ec192d038/you-get-0.4.555.tar.gz"
  sha256 "a90f26c8059240803b1c0a9ed9816af3f1831b9d8ffb9be572a0f5fb4f6eee4d"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "93cad5940cd279d002bda52ad67f09c0e21cc3885dc403102b6482d14aaa80c8" => :sierra
    sha256 "eab34fa55bfa798261c7ca8ade69e7a6a0852455bb9bfb5def248616437429ed" => :el_capitan
    sha256 "e78c50a40e63e38dba722f01e053735f60572ce8a0c5c5d6192f63a4c4c8e2d3" => :yosemite
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
