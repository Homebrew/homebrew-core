class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/01/65/3830393a7abb7f744fd2a85324859aa67d9979a4fa0cbdba4d2ec192d038/you-get-0.4.555.tar.gz"
  sha256 "a90f26c8059240803b1c0a9ed9816af3f1831b9d8ffb9be572a0f5fb4f6eee4d"
  revision 2

  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    sha256 "94b0e9a49cd0c8445030670392c6f04f3ccc20cfbdf5b1a266771ae39c265f03" => :sierra
    sha256 "9a9c1cd6661cc8c83938b63b9b6cbc4f6823c3189ec44f1eeaefa36d1db5d0cb" => :el_capitan
    sha256 "1c121279de4f471509dc055fa01930ce9510e06d7373a1665be9782622e66d2f" => :yosemite
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
