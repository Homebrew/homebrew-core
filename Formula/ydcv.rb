class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "3006d55cd6f84acacbeaf18006ef35182b07f23dacb15ccb034958ae8d2be1d6" => :catalina
    sha256 "52d7d12528b70474438cfa6fa6b78fe2769297e3f7ca2867ddfa83f537ae001a" => :mojave
    sha256 "669241fe767681f5728da484a6d8f70769675ba0bec96ca73200c2fecd3333e3" => :high_sierra
  end

  depends_on "python@3.8"

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
