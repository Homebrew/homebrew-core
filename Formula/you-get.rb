class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/10/71/fc855ecf52cae5cf2844a3fcc13091fd90f94566bd1d95e4456eef893544/you-get-0.4.536.tar.gz"
  sha256 "6d731e1316f58435a291ad07bc572da7d77129fd211d6e1796d6d55e45f84537"
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
