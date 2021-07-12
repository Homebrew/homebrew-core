class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/8e/93/cccb8a10b0845fda8448304e074d6e82cc915d233e504a99fc043c18477c/you-get-0.4.1536.tar.gz"
  sha256 "78c9a113950344e06d18940bd11fe9a2f78b9d0bc8963cde300017ac1ffcef09"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "880ca7781c0024c3ab49c5d4124dedbf5c5e8f3f225b9db8308f65f5c73e7c71"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
    sha256 cellar: :any_skip_relocation, catalina:      "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
    sha256 cellar: :any_skip_relocation, mojave:        "9c8a5b19914e33be141651d2919abcd9e172d7aa49048050a943e0e3a7fc3119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f127036e6dacecb21abd59c05e5d9f1f3517162b0296a62c4759a39cfdcfbad8"
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
