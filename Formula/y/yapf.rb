class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07fd5b4d90ce1fcd6ed7b89aee9bcb446ae3bfe17a2482540e8206a5fbfb7282"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07fd5b4d90ce1fcd6ed7b89aee9bcb446ae3bfe17a2482540e8206a5fbfb7282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07fd5b4d90ce1fcd6ed7b89aee9bcb446ae3bfe17a2482540e8206a5fbfb7282"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e811a83e62d349bb582cc9fdb0e2517ad107e60462a782c2e111c6c5c9027c9"
    sha256 cellar: :any_skip_relocation, ventura:        "2e811a83e62d349bb582cc9fdb0e2517ad107e60462a782c2e111c6c5c9027c9"
    sha256 cellar: :any_skip_relocation, monterey:       "2e811a83e62d349bb582cc9fdb0e2517ad107e60462a782c2e111c6c5c9027c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdef089e7f7464ad430cbdf4f7616eef0cf436880670acf67ec4a9cbb7f878f3"
  end

  depends_on "python@3.12"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/20/ff/bd28f70283b9cca0cbf0c2a6082acbecd822d1962ae7b2a904861b9965f8/importlib_metadata-8.0.0.tar.gz"
    sha256 "188bd24e4c346d3f0a933f275c2fec67050326a856b9a359881d7c2a697e8812"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
