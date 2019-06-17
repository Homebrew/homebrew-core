class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/0c/ad/1dd7e729e9d707c602267ed9a6ca9b771a507862f85456bf18f5fff8f0d1/yapf-0.27.0.tar.gz"
  sha256 "34f6f80c446dcb2c44bd644c4037a2024b6645e293a4c9c4521983dd0bb247a1"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
