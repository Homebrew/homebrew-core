class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/c2/cd/d0d1e95b8d78b8097d90ca97af92f4af7fb2e867262a2b6e37d6f48e612a/yapf-0.32.0.tar.gz"
  sha256 "a3f5085d37ef7e3e004c4ba9f9b3e40c54ff1901cd111f05145ae313a7c67d1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a25c9162e29ad3b06cde091efdfabc4181b24256bcd50091eabd5ed534c45161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a25c9162e29ad3b06cde091efdfabc4181b24256bcd50091eabd5ed534c45161"
    sha256 cellar: :any_skip_relocation, monterey:       "7ad8f128e5f4f718b996176bb36d47b3f32083f1e60b58793a82a6530b2eb56c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ad8f128e5f4f718b996176bb36d47b3f32083f1e60b58793a82a6530b2eb56c"
    sha256 cellar: :any_skip_relocation, catalina:       "7ad8f128e5f4f718b996176bb36d47b3f32083f1e60b58793a82a6530b2eb56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8781942adadad33fecf2bb9e527116939c2c51a9674ceab4ec97d48d91da3748"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
