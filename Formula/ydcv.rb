class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.6.2.tar.gz"
  sha256 "45a237fba401771c5ad8455938e6cf360beab24655a4961db368eb2fbbbfb546"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0f4fb06ecf1aade03aa1851ec9cc4b75e10aaa5a95177440eeff02e07238e32" => :mojave
    sha256 "3cd596b113010dfbcc5577c1d5b57bfc09e6b6ec843795c6d1aaf7e50690a5c7" => :high_sierra
    sha256 "1e716fe115344fce903575e5843d380c0edea040725e7548af0ff9b03bdd5bd2" => :sierra
  end

  depends_on "python"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  test do
    assert_match "hello", shell_output("#{bin}/ydcv 你好")
    assert_match "你好", shell_output("#{bin}/ydcv hello")
  end
end
