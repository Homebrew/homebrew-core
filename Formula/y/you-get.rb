class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/2d/85/f4a22b842bc0e0f57dc56ae54266dbc451547cee90bae9480131100ad92a/you_get-0.4.1743.tar.gz"
  sha256 "cbc1250d577246ec9d422cef113882844c80d8729f32d3183a5fa76648a20741"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314517f0c46140c29745902c95fbf80a60afb055de554b4ffe5403d767d4d883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cd9cd65f4ca5491d85a72c8c28c38af2d9c5fb5929b34ca60644c69e9709fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aa9c9a1fd96d1206f118671ecb8c96b8099d5f8b41687bcebdf926471e274f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b37d0b79da427ea6c53fe8bdd7f1ec8ed1c4fee6f5a150ebd2ebfc753cadfd"
    sha256 cellar: :any_skip_relocation, ventura:       "1a424c4a6418d15823742c255050cd4920dddc672e356619245da96a0cd3be4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa525d0b64ae9895f90d12944bb16af68c82ed78e160decacde3c749bea32637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0837e95bc4aab5d8797a4f11f9de319bc1e132115151f5f0e5fcbcbd272b49"
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
    assert_match "82 bytes", shell_output("#{bin}/you-get --info https://imgur.com/ZTZ6Xy1")
  end
end
