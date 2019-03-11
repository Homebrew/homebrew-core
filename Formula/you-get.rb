class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1270.tar.gz"
  sha256 "5fb1540242b4051334fb4933a24ca128955e230cb637b203869a5a7b04d1554c"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ffb0654cffb1d4c152b5e01ae7186338b81fa3c5530b8b5500985f208524d5f" => :mojave
    sha256 "018012b987a86f2413cad6b5844bf7e21c40eab37fedd8b330336d6dd3eeece4" => :high_sierra
    sha256 "983d69ad520a3f5fe36fa073a36d48f375e8c66c490fdbb33209dc917c652b8c" => :sierra
  end

  depends_on "python"
  depends_on "rtmpdump"

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
