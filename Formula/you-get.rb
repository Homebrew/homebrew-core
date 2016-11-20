class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.595/you-get-0.4.595.tar.gz"
  sha256 "c366ccfa14e334fe9320b52582a4a41c5d396181fadc5d82eb2dda1f7f5d2a70"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "94b0e9a49cd0c8445030670392c6f04f3ccc20cfbdf5b1a266771ae39c265f03" => :sierra
    sha256 "9a9c1cd6661cc8c83938b63b9b6cbc4f6823c3189ec44f1eeaefa36d1db5d0cb" => :el_capitan
    sha256 "1c121279de4f471509dc055fa01930ce9510e06d7373a1665be9782622e66d2f" => :yosemite
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
