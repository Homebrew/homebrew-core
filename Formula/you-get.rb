class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/7b/7d/fe93719aadff3814695dc30541324aba9da422a3800a1942c5e5d2457ab0/you-get-0.4.1527.tar.gz"
  sha256 "470b2f76ccad5dbe37bc4a8779056cf6da67f4322fe723e2b9227e825da595c9"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "880ca7781c0024c3ab49c5d4124dedbf5c5e8f3f225b9db8308f65f5c73e7c71"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
    sha256 cellar: :any_skip_relocation, catalina:      "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
    sha256 cellar: :any_skip_relocation, mojave:        "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
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
