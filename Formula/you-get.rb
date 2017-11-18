class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.964/you-get-0.4.964.tar.gz"
  sha256 "713ebc989fabba349103c38541ef26a0acc1a1d8d4a4188ffc666fb6f1587df7"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6ec329502815e281a972daeb65248c8986f7d82a4879021456f4de43c1d02c" => :high_sierra
    sha256 "e88f6ac7e2d0ffdc3f51ee8efb7001d8717d105d6df4a652b69d2ab78c1831bb" => :sierra
    sha256 "661460646ada22fc4842dba9068a268ea5ff920a16b79689741099ed84482fbc" => :el_capitan
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
