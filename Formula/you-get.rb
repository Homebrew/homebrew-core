class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1193.tar.gz"
  sha256 "74046ba4994630db7f66145f318d76c5c7bc8802a42b8c6e393909b1c86326e8"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd6c7720e5d550d693ed516d27eadc6009b894a538fcf796e21605952b244bd2" => :mojave
    sha256 "511e138f72d06117fa4a5b2cf91f5cfd88d038e7731d11138e71886027a5b576" => :high_sierra
    sha256 "827e22804664d4644d05d6f9abab6620729b1ab588f1990b022317248813f1c8" => :sierra
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
