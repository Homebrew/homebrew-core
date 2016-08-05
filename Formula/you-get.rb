class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/93/bd/f7a81c7b73d3a7bac9f254ec11854c70ab2f5c22dcdbefbe01573faee014/you-get-0.4.523.tar.gz"
  sha256 "01e51b48665a7b3de97394c9ad8e34e510664ffdada6b4f1fcf1651977e8347f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4d69de3f770f94f5ed25376cc7921739ff65c25cda4256f11cce9f71a7a65b4" => :el_capitan
    sha256 "dd03eacedc9ddd1d89e9884698d590932379538597cf81993d66269b714c1196" => :yosemite
    sha256 "20b17d758a0b76ecb24e15122f33127ab8d401f9023b7bcd7701d73375950076" => :mavericks
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
