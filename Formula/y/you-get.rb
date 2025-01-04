class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/2d/85/f4a22b842bc0e0f57dc56ae54266dbc451547cee90bae9480131100ad92a/you_get-0.4.1743.tar.gz"
  sha256 "cbc1250d577246ec9d422cef113882844c80d8729f32d3183a5fa76648a20741"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19a25f252fdf9e745696c92b25e2f94a68c35a14bb5abb5d9c9173bbd2b88f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b69e1ed11567beb060af0dc1ca6b866a50d0852c7462cc5171a59946183bfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbeb9ccf0eeccdbd16b292d3845af8870d04a98580abe63218e6719fd8e9b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd18933cb33bd106f69dd548b93ed663ce3cb408eab047232fca5d6b8d46fb38"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3e140c94f095b8fc2bc91382a75ca76f639bbef56c9be89f5f70b31e603138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307a7aa5cf2a671b668a8129406d209ad209872c16bd511c4ba969a8fc54a0c7"
  end

  depends_on "python@3.13"
  depends_on "rtmpdump"

  resource "dukpy" do
    url "https://files.pythonhosted.org/packages/dd/fe/8cef39f269aed53e940c238bf9ceb3ca0f80d7f5be6df2c00a84d87ac5d8/dukpy-0.5.0.tar.gz"
    sha256 "079fe2d65ac5e24df56806c6b4e1a26f92bb7f13dc764f4fb230a6746744c1ad"
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
    assert_match version.to_s, shell_output("#{bin}/you-get --version 2>&1")

    # Tests fail with bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
