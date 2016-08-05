class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/93/bd/f7a81c7b73d3a7bac9f254ec11854c70ab2f5c22dcdbefbe01573faee014/you-get-0.4.523.tar.gz"
  sha256 "01e51b48665a7b3de97394c9ad8e34e510664ffdada6b4f1fcf1651977e8347f"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "95e8a067a9266c2bce3addb1c7f41a874f5623f1280943756eb60caa0fda019e" => :el_capitan
    sha256 "955a72c1b6361c3412604757e3e4c8c18f1e9ff425b393f60df0058982aa507a" => :yosemite
    sha256 "a42c716010a95cb3ea85b7f58626df1c720ea15c282ce600bd7cfcc5960abe83" => :mavericks
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
