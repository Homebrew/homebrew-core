class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/0c/ad/1dd7e729e9d707c602267ed9a6ca9b771a507862f85456bf18f5fff8f0d1/yapf-0.27.0.tar.gz"
  sha256 "34f6f80c446dcb2c44bd644c4037a2024b6645e293a4c9c4521983dd0bb247a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "67911f42c81041f0d536ca48fec3aaeacaed7dae99c62729c8eb6d35760a8c7e" => :mojave
    sha256 "2c886ed4aafbd5052a3d1221c282de5c7a5aa927dd3ba5bed2bc3ec29ac8946b" => :high_sierra
    sha256 "cc84f98a4cdfd183c2ba7b86ce21612e063d22d2574559474dfeaa64281f8d03" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
