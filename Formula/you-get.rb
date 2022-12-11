class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/92/39/423701a8346435292fdde5ad78beb5437ebb7718f6faa16e1546d3ef479b/you-get-0.4.1650.tar.gz"
  sha256 "b3c944cf7a63cc468cccc8816dce7fc008c2e6b5ba52aefe5ce2081818a3ad47"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc87aa728c1dea17c74a6c71e3d7fbd19973c1e0b92f3cf420f795e1504bea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc87aa728c1dea17c74a6c71e3d7fbd19973c1e0b92f3cf420f795e1504bea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc87aa728c1dea17c74a6c71e3d7fbd19973c1e0b92f3cf420f795e1504bea6"
    sha256 cellar: :any_skip_relocation, ventura:        "656de5b16c513deb23076097ce237964770dff6940284bc9f9a4aa3213804af9"
    sha256 cellar: :any_skip_relocation, monterey:       "656de5b16c513deb23076097ce237964770dff6940284bc9f9a4aa3213804af9"
    sha256 cellar: :any_skip_relocation, big_sur:        "656de5b16c513deb23076097ce237964770dff6940284bc9f9a4aa3213804af9"
    sha256 cellar: :any_skip_relocation, catalina:       "656de5b16c513deb23076097ce237964770dff6940284bc9f9a4aa3213804af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23402d3616b52f763e12b8a0b04bfb7b49d58e7fd61fc35fa4a08d9361f88a47"
  end

  depends_on "python@3.11"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
    bash_completion.install "contrib/completion/you-get-completion.bash" => "you-get"
    fish_completion.install "contrib/completion/you-get.fish"
    zsh_completion.install "contrib/completion/_you-get"
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
