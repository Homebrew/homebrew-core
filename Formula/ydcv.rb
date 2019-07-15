class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"

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

  def caveats; <<~EOS
    You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
  EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
