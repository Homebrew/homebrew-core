class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://files.pythonhosted.org/packages/1f/29/17124ebfdea8d810774977474a8652018c04c4a6db1ca413189f7e5b9d52/ydcv-0.7.tar.gz"
  sha256 "53cd59501557496512470e7db5fb14e42ddcb411fe4fa45c00864d919393c1da"
  license "GPL-3.0"
  revision 3
  head "https://github.com/felixonmars/ydcv.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "329fe285ec1d389d1dd876bd4775327be3781a2c4a336537790b5d43a0bf5449" => :big_sur
    sha256 "95ef9e1189ea9279282e41a64a9bf0b50c7e7a377b450d0c1508ae1597b89a91" => :arm64_big_sur
    sha256 "f6984e690a8d4fab4b893cea60ead8c6cc53358066d1b255e7e49ff952f300cf" => :catalina
    sha256 "606b5e4d75d322b8c5ed787ccdd6729bbce88f7039731a958352d7d0445e1e1f" => :mojave
  end

  depends_on "python@3.9"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
    EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
