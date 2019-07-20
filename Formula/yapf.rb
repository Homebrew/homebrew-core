class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/89/41/7f7c884531730c0cb471764e1ddf50f59d25bb2ab258ede633264344e9cb/yapf-0.28.0.tar.gz"
  sha256 "6f94b6a176a7c114cfa6bad86d40f259bbe0f10cf2fa7f2f4b3596fc5802a41b"

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
