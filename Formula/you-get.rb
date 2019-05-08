class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1295.tar.gz"
  sha256 "491a2ea31c105a2c691fd7a1d284b832ea7b4db45a2c1bfcbac6677e4db9d296"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "38a070da39386a48f670de54ee9b6fff27a8616bcf244962e015c828ca25fc7a" => :mojave
    sha256 "cc612cfd1b25815a813af6ccfaee554cfe94d9f9f708612087e4762766354ad4" => :high_sierra
    sha256 "f445b4de8abfd2b1f8416265e5125eae00d0092140fdefc923198f099af686e1" => :sierra
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
