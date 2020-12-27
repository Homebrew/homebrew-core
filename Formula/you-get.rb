class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/b3/eb/e24fa3352fa27e1be3b7f8b3d158a3b12f6ee294c09614eb61b5d85fa054/you-get-0.4.1500.tar.gz"
  sha256 "5a6cc0d661fe0cd4210bf467d6c89afd8611609e402690254722c1415736da92"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b53a803d844d85abe7f6a14d3ef33fc8867595bc5f58e35f5c4229aaf04f7b8a" => :big_sur
    sha256 "be8623a5faa96a3bb083e03b6340a72e7209b50d35e0fddb9b6f9dc230adc4ad" => :arm64_big_sur
    sha256 "b3c8d2f9616e12c4c97896bdedd334ec69c206bbe521d187c226f4d7a5edcdca" => :catalina
    sha256 "0a8e12599e2eaaf5eceddddb75c04cb3c83a37eb80fbe385023dd05774b11b17" => :mojave
  end

  depends_on "python@3.9"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
