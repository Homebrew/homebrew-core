class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1355.tar.gz"
  sha256 "5e45c92de6d1ad2f5dd0a7491af6a695910cf72ca82b2c3ed0ce2520e6daabd8"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "0528d4f83be9cc6decfab0ec71949c5585ebec0e865b3430d859702e15e73ad1" => :mojave
    sha256 "13ac1687ac8f74bf16b33a765a94f77bc52cac5b315b80bdcdf0fba2aaac5fa8" => :high_sierra
    sha256 "2738173ee189075104a6dfff126fe7aec963ab7648247abbf72213c174076a61" => :sierra
  end

  depends_on "python"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
