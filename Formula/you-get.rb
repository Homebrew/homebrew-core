class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1011/you-get-0.4.1011.tar.gz"
  sha256 "0f0504c7049ee8b664c60b184a49bf494d2783d6d86cdd13d260b0e8ecd5ca40"
  revision 1
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf36a3d3d48ea141b7287c98d8804004aca43cb0c8a261a5be52ef2277f2630" => :high_sierra
    sha256 "f08df909178b648bea1c32077a413100bd82e6906c1a3764bf1fbe153d54b8cb" => :sierra
    sha256 "df84283a5e29cd71b0468680352fba7024affc46f8a1c55d420149dcdf0a3403" => :el_capitan
  end

  depends_on "python3"

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
