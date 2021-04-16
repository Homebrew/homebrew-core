class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/83/f5/fe13c4859e9f7007fd995ecf6a05b85237c879323d070d54d9815f8e0e15/you-get-0.4.1520.tar.gz"
  sha256 "890be0c9637ae571bf5ead8015c4fe1e75de8adeae3aece545a1c4aeb8282fab"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bea8c3b1b8d6f19d8f0f3fc9ec499d061a8178e1a068952dd64b1c4f37adb78c"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a5b7e6b35b3050c0034b9c1e8687c833feee4ef1bfaba8a639b1c0ea5b6047d"
    sha256 cellar: :any_skip_relocation, catalina:      "3e2e928c47300d7585a8c7d6d0a602ca847b32257a543a34e20be1c2e41d2b6b"
    sha256 cellar: :any_skip_relocation, mojave:        "e8d8cc06b0169589d65bdbcd931141b417ef7a6450ea7734401dfe2f2e074b35"
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
