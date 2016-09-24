class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/10/71/fc855ecf52cae5cf2844a3fcc13091fd90f94566bd1d95e4456eef893544/you-get-0.4.536.tar.gz"
  sha256 "6d731e1316f58435a291ad07bc572da7d77129fd211d6e1796d6d55e45f84537"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "f703f05dce8bfdef7b135524d112f672d0244ee473dd3a4cd07c94e4b0b47418" => :el_capitan
    sha256 "a3deb9a51333f9d5b7d8e6c855c1128a6556ac8aff1166293488079905f161bb" => :yosemite
    sha256 "4be88f87138bcaadcf85fe5cc9a7b475e548630b3a5e96884fbfb6a64f1d109b" => :mavericks
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
