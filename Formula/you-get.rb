class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/01/65/3830393a7abb7f744fd2a85324859aa67d9979a4fa0cbdba4d2ec192d038/you-get-0.4.555.tar.gz"
  sha256 "a90f26c8059240803b1c0a9ed9816af3f1831b9d8ffb9be572a0f5fb4f6eee4d"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "f703f05dce8bfdef7b135524d112f672d0244ee473dd3a4cd07c94e4b0b47418" => :el_capitan
    sha256 "a3deb9a51333f9d5b7d8e6c855c1128a6556ac8aff1166293488079905f161bb" => :yosemite
    sha256 "4be88f87138bcaadcf85fe5cc9a7b475e548630b3a5e96884fbfb6a64f1d109b" => :mavericks
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
