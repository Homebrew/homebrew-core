class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1328.tar.gz"
  sha256 "8df0c26d41c41975d0d8b7d73e64afe2d80d1f74e1fad264e8fae1eea5441a78"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a16d5cb1e0159d4750f1453cbe0814c3eeba309bc6906df426a9dc995e8a82a" => :mojave
    sha256 "36211043db5029d7c4ed660c2d3f4bb28c35e2820af18c186039411b35594c6e" => :high_sierra
    sha256 "1363ba0e4b13eccfaf8c63462cf54541a4efb83ea11eaaac195ef8175a6b7271" => :sierra
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
