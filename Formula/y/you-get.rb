class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/09/1e/96540e807ec3b103625e9660e7a2c7a7eb9accb1b90bf85156ff50e2dfd3/you_get-0.4.1718.tar.gz"
  sha256 "78560236a4d54ad6be200d172a828e39f49c0f07c867dcf1df670c66b5b7f096"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d25efad73bed5c8e4f9db2168a04091a3016eb250acd2b13ff70c609bbb8b49f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "146364f8654a014b96a073ed0a1930952101a8879fa44c649b4e53e5081b9534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fff144f83485ef99412b469080a382bb373f827021e75402867d7157789129a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7212a065dd2b2d973d3683e8694e62744b1c8383843f70c266596babec9376c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a3edbb32b61ed06db36dd323703a56988f9f8e56e03569148abc58016867e761"
    sha256 cellar: :any_skip_relocation, monterey:       "39e8a008e755967a80cdf015c175be46e440f499866abd6896b98f103d051e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc8917af8c27749dab9d801304b1cd7ab7b96bf8ceb9990ec21b2ec0973dccb"
  end

  depends_on "python@3.12"
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
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"

    assert_match version.to_s, shell_output("#{bin}/you-get --version 2>&1")
  end
end
