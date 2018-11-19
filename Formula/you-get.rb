class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1167.tar.gz"
  sha256 "b966b25359fa18f81188c94ab4febb4cd14c011712391bf197fe21be77642b6a"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "41c4d085ea52fc80f8f48991a7997f6c32bf012283fcdb8930553ec23ea58595" => :mojave
    sha256 "a53a2699b6ddf7f791df924ae8243512cea9dff03ab06e546b46f338dea22986" => :high_sierra
    sha256 "30bddbba107eda7835afef2fcb6114f1c0c91eac3660c9834fe2f1ac3ec852b6" => :sierra
  end

  depends_on "python"

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
