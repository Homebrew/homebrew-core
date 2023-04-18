class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/92/39/423701a8346435292fdde5ad78beb5437ebb7718f6faa16e1546d3ef479b/you-get-0.4.1650.tar.gz"
  sha256 "b3c944cf7a63cc468cccc8816dce7fc008c2e6b5ba52aefe5ce2081818a3ad47"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10cbedc1662e5e93abf11da1dbfdfcafece91370708bb7bd2a90563424a941ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10cbedc1662e5e93abf11da1dbfdfcafece91370708bb7bd2a90563424a941ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10cbedc1662e5e93abf11da1dbfdfcafece91370708bb7bd2a90563424a941ba"
    sha256 cellar: :any_skip_relocation, ventura:        "937b557473bf5b2d762c4d78bfb44f755353c429d1e370c36de26487b26c4949"
    sha256 cellar: :any_skip_relocation, monterey:       "937b557473bf5b2d762c4d78bfb44f755353c429d1e370c36de26487b26c4949"
    sha256 cellar: :any_skip_relocation, big_sur:        "937b557473bf5b2d762c4d78bfb44f755353c429d1e370c36de26487b26c4949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5144f23c00dfd8ffc7379be1c542f464a5644e7c586bbc35b1c62fd6fb23f4"
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
