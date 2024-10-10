class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/42/f3/c4bdf49e31ac1c6bc477711a4ec6a276ae0745a3b8fb143c161bf32e8b49/you_get-0.4.1730.tar.gz"
  sha256 "65457b7b8893f08c082532eb34998dc477f533d32568be3bb34e592bdcb44f88"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bafc5d5d91a772f38bc134830e6841f222b8cc1d7070d2c2427a4aa6bcfed0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a52b05849945520bcd8aeff458358127f29fffd583639c4489950b7fd5c25346"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01568a2dce093060697dcd39cb36609a584d5323a1caa42ca6a546586d0d5076"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9babbd967c9beb68d6e08a9fa4f7b4d3a90d61bf1ec4715e1776f00eddedcd"
    sha256 cellar: :any_skip_relocation, ventura:       "44a775b683865ba5d95cc014b619abb1eac7d3593775a174622ef0a7cb8ae8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919d3f808e317229b5e32a4eecb1ec539388287d56fd177fe36900c74a9b3dab"
  end

  depends_on "python@3.13"
  depends_on "rtmpdump"

  resource "dukpy" do
    url "https://files.pythonhosted.org/packages/d1/0b/402194ebcd92bb5a743106c0f4af8cf6fc75bcfeb441b90290accb197745/dukpy-0.4.0.tar.gz"
    sha256 "677ec7102d1c1c511f7ef918078e8099778dbcea7caf3d6a2a2a72f72aa2d135"
  end

  resource "mutf8" do
    url "https://files.pythonhosted.org/packages/ca/31/3c57313757b3a47dcf32d2a9bad55d913b797efc8814db31bed8a7142396/mutf8-1.0.6.tar.gz"
    sha256 "1bbbefb67c2e5a57104750bb04b0912200b57b2fa9841be245279e83859cb346"
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
