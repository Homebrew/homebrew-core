class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1256.tar.gz"
  sha256 "8f5dad64c806b0362dc81abdbf6767d74b60a31074af09d52ce8e096307b90cb"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ad63a446f5ab70b52cd2bd775843380ec900e46d02c5ca1c2a632b80c7c44c1" => :mojave
    sha256 "ff85e442c9f15ba378f74e025f530e0ba603a9259fe59b6b9c60f668576cacbb" => :high_sierra
    sha256 "82a9c4664b52c90da14c1702c2c0a13cc737f3e23a898d28ec657f8a55e7d698" => :sierra
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
