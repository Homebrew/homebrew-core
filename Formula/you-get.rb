class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1099/you-get-0.4.1099.tar.gz"
  sha256 "331e43185e309d13943de2aeafc2c19cbe2f2af67a46f920106bbd2d76873ffd"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f664bafcc1a45b29ac21ececce9bd59fb8191008d178c1e76dfbbb7cd59cecc2" => :high_sierra
    sha256 "831532c3ba0a4f4bff5a5eafc76f6046a0ae4cd5eec8852c3d8c35b07ed94a64" => :sierra
    sha256 "57cb8564871ea385315a0345d11844d2b68b6bf7f307d416968e3a816d67467b" => :el_capitan
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
