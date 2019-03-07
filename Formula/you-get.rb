class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1256.tar.gz"
  sha256 "8f5dad64c806b0362dc81abdbf6767d74b60a31074af09d52ce8e096307b90cb"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a796e2ca52021684b22956210974e98ee1aa5cb3311fdd5f8d65faa52b685363" => :mojave
    sha256 "fae019533cf4f03d85e31ba68f7b54dc1a6247ff6196514ab748826939f0a6de" => :high_sierra
    sha256 "8037a36a2661e148ae7f67f4c7075024ea978b381dcea3e65facd17d7f79faed" => :sierra
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
