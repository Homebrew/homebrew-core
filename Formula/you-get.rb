class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.964/you-get-0.4.964.tar.gz"
  sha256 "713ebc989fabba349103c38541ef26a0acc1a1d8d4a4188ffc666fb6f1587df7"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7055caf5b7b7847ad796d375a457c6e09780076c217d7fcc1289640b9a33d49" => :high_sierra
    sha256 "1eb0f62c4f7f1b696a6df7f885fd99bfd3fa2fb256f7b7080f9df06deac69511" => :sierra
    sha256 "e068923fa0a5fdcfe40572dd4d5eab604c32380c0a12575ef2784fd478d5bd20" => :el_capitan
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
