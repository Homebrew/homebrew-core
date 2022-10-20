class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/ba/16/9c3660c4244915284cd7ce1f7ba3304cec29bdf3ef875279b3166630f6be/you-get-0.4.1620.tar.gz"
  sha256 "c020da4fd373d59892b2a1705f53d71eae9017a7e32d123dc30bef5b172660e6"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad6a32d2ad413e55f9674a7eb6a43f1060b050b12a0a46408d687f9858564831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6a32d2ad413e55f9674a7eb6a43f1060b050b12a0a46408d687f9858564831"
    sha256 cellar: :any_skip_relocation, monterey:       "3d665a6eb3292501d2bd2994b0718088799956dad03aa1ed69535688745a95a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d665a6eb3292501d2bd2994b0718088799956dad03aa1ed69535688745a95a5"
    sha256 cellar: :any_skip_relocation, catalina:       "3d665a6eb3292501d2bd2994b0718088799956dad03aa1ed69535688745a95a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc849516bfcd0fee0cd119b702c49a9bdfeefa5faf8bf570408dcc10a1296a33"
  end

  depends_on "python@3.10"
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
