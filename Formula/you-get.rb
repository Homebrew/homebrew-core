class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1167.tar.gz"
  sha256 "b966b25359fa18f81188c94ab4febb4cd14c011712391bf197fe21be77642b6a"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d3c2e7818ddf6860fcdabab6fb44bdc3ccd3964d5e069c3d258ecd585e7b9db" => :mojave
    sha256 "716b0c2d49416641b57c0e738c2f5cfe7cf8638fd94535d8c0121f2ba4ea5681" => :high_sierra
    sha256 "12d231acff7757c1b75b48991f6e0755d418e1ff1d5209c41d6e5b9b07ade53c" => :sierra
  end

  depends_on "python"

  depends_on "rtmpdump" => :optional

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
