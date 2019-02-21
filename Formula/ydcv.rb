class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  version "0.6.2"
  url "https://github.com/felixonmars/ydcv/archive/#{version}.tar.gz"
  sha256 "45a237fba401771c5ad8455938e6cf360beab24655a4961db368eb2fbbbfb546"

  bottle :unneeded

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
