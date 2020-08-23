class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/65/44/c2aa8743cada222eaede6b9bd4b644e84f04eaa6dede2258ec7562b705d3/yapf-0.30.0.tar.gz"
  sha256 "3000abee4c28daebad55da6c85f3cd07b8062ce48e2e9943c8da1b9667d48427"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d01c7c5f1bf9e9aa845dc219215902089bd4840058207b886699b6aaffa89e95" => :catalina
    sha256 "2382d1e94fa1ee30967decf41c62bf83d9d72ac7be41ae6d267fee68b52297c7" => :mojave
    sha256 "0827bfff5c9ea969e54f97302298d4fb2861d91b6baae4f8c4cf3f6e84f44cc2" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
