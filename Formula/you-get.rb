class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1388.tar.gz"
  sha256 "17bbb545efbd0898fe48311df33d6288049dcae5f4a2132da70a1072f019b96b"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1ca1bef023aed9573128f3d38a42d79671da2fa72119cdee42a6647298eb9c7" => :catalina
    sha256 "a0158ed4768494c37f2a300ccb5fe73f8b3859e7fd8860d10e1b1b7865299ce3" => :mojave
    sha256 "4ab0eec8eb3928ad5b784cd8ea53b8c20d028139b2fc839e064fa694595e9f7a" => :high_sierra
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
