class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "c58351df91ff5461873cb5cae4dcecc40d8f2c64d15152b95c279a1624fe01d0" => :catalina
    sha256 "8ea0db97fbede09e11d8890652db0128197c8fb551796efdf795c73021c1d578" => :mojave
    sha256 "906ce5ee60c5b2c8d4c90b42fbc8e08cafd67de0df9f9b63bd7f4a0f428073c7" => :high_sierra
  end

  depends_on "python@3.8"

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
