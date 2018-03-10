class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1040/you-get-0.4.1040.tar.gz"
  sha256 "fdc9021e8b1cf936aad4bd6c74b80ea8fa3573b807c41242ba781e247f8c8ca8"
  revision 1
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "95ae46109f0f7af32dfd21b426de233875c62531d64518f95e382897e8dff990" => :high_sierra
    sha256 "9da7e0ebe95f6305a2339f92e8420eba1a813282c14835631cde7df6fff5c7c6" => :sierra
    sha256 "086548ad1f80e53b4830ed65e5e18c1475f80b86e4cf08465f420827043ecc17" => :el_capitan
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
