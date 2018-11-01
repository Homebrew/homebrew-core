class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1164.tar.gz"
  sha256 "007058dfddd14a9119664308deabef789840fdaaeb2aff9ddb5e024dee559ef1"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5af76090544e0f7e20b358dac45b7a234e221213535932509a7e3acb076d81" => :mojave
    sha256 "7db6974538db6230638feefd643c72431d292a374f6480e95b19bedbcd41eb68" => :high_sierra
    sha256 "2757ac9bd335cd2490ca029a471664c1ebeee3ad8fb122a9f1a94d0883651987" => :sierra
    sha256 "73848e6f4bed7b9f7d6563f891a3198c4fa6ff0e3b6c00876391776496517615" => :el_capitan
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
