class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1077/you-get-0.4.1077.tar.gz"
  sha256 "2a4c197c70a442e75b894f10ea78c35c16e11029e8f685811aa3e4f57eb0c4e1"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f97cef01fc0127da3cc8f292ca4c80259eb174f69cb8b4b78918aff28d7902a4" => :high_sierra
    sha256 "f1885e7d1dbd86095a5511b2153f7c0e2f15297de5e9722e935bddbbc150cff4" => :sierra
    sha256 "e5dabaa9a8cca263c764553ed5b986aa768a0abfbf1092617353c86fd8502ef6" => :el_capitan
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
