class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/2d/85/f4a22b842bc0e0f57dc56ae54266dbc451547cee90bae9480131100ad92a/you_get-0.4.1743.tar.gz"
  sha256 "cbc1250d577246ec9d422cef113882844c80d8729f32d3183a5fa76648a20741"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5af36643b679d3ed5136e13626d1a0bffcfb1aaa8ea4f80c3e1b78c9be6db4a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24db47cca71c512e6193a0c85e8ffb202e7d950dab53a4789999d7ea4ffcbe04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "286f972ec36ca0369017c18819239f1b8777021462bde933a61fa372bd63ad87"
    sha256 cellar: :any,                 arm64_linux:       "1cd18975dfacfa7568d12495808c908eb0fcf7b923bbbd1b58bebcb2a442b480"
    sha256 cellar: :any,                 x86_64_linux:      "5c0bc5d85992d0d63c2ebc91b252784f7960862ce2d2889a08309a91e4e4caf6"
  end

  depends_on "python@3.15"
  depends_on "rtmpdump"

  resource "dukpy" do
    url "https://files.pythonhosted.org/packages/85/f5/0d731f71f68a784e9637c74bfd93ee36666f303da1ad32fed5dc26a54bed/dukpy-0.6.0.tar.gz"
    sha256 "f8b1d1f75c6a5be9b525dc80f05b6c869a671481be689da146b2c6937b3450ee"
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
    assert_match "82 bytes", shell_output("#{bin}/you-get --info https://imgur.com/ZTZ6Xy1")
  end
end
