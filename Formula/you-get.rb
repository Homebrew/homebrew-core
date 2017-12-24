class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1011/you-get-0.4.1011.tar.gz"
  sha256 "0f0504c7049ee8b664c60b184a49bf494d2783d6d86cdd13d260b0e8ecd5ca40"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "70f791b3a5c497cf13327205019235d30d927b3f3f38f794012116416843003c" => :high_sierra
    sha256 "58fa58f07a1ef5c08b0ce11fd692cfe8d610672fafd5f119480de9271f81f022" => :sierra
    sha256 "24c5d9053d7cc080c1c5fef9c341cf30f9c5a4e17f81579e9cb745102e0aac43" => :el_capitan
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
