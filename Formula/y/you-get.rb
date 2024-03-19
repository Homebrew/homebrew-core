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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a8b5077c1235ebe12d7a5fd8f69724fec9a8ef17305c1e807073daa500de253"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d1e898a9109cc895bda7b81990150439d356af30bdf8e98cf3fd0f8be2c9158"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd328f83f3ad81597e30958dc22c0342066a1acab8e35706056da47256a76ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8e9c2794b890b68ca0f8ff2a394d2d95d5e69d8f201109151b0dffdebe27f14"
    sha256 cellar: :any_skip_relocation, ventura:        "ea3bc507cf699314cab4eee92f3e5cc0d343cd87e7d2a3f9858f3eb7732956ec"
    sha256 cellar: :any_skip_relocation, monterey:       "e4afbfd0a6c182751edf23f07bc7a459182fa494854003fbcfc554dbd93a844e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dae4ca3134063cdc80d51525059b054d89cbcd17d3f247a890c093252d77083"
  end

  depends_on "python@3.12"
  depends_on "rtmpdump"

  # Support Python 3.12
  # https://github.com/soimort/you-get/pull/2677
  patch do
    url "https://github.com/soimort/you-get/commit/aedf3e458f3ec6083ebe4c3e3c0f21e1eb582000.patch?full_index=1"
    sha256 "a585310a37a54bcbe077bcbff99f39dcbfe53457179dbf035409cbdda042275f"
  end

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
