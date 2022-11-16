class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c6/63/3a87df61a5d8e1b2ba116f4889f3dbc2717ebe2e34c77b2d34e4e6b9deef/SCons-4.4.0.tar.gz"
  sha256 "7703c4e9d2200b4854a31800c1dbd4587e1fa86e75f58795c740bcfa7eca7eaa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa18ea62fe2e200bc398f7cfa52c480877ac55336893aa749ef4a86328e8bd14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa18ea62fe2e200bc398f7cfa52c480877ac55336893aa749ef4a86328e8bd14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa18ea62fe2e200bc398f7cfa52c480877ac55336893aa749ef4a86328e8bd14"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d6e507ea5bbeabae6fa2798e660bd809a240aad0fb33f89bbecf4795157448"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d6e507ea5bbeabae6fa2798e660bd809a240aad0fb33f89bbecf4795157448"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d6e507ea5bbeabae6fa2798e660bd809a240aad0fb33f89bbecf4795157448"
    sha256 cellar: :any_skip_relocation, catalina:       "f6d6e507ea5bbeabae6fa2798e660bd809a240aad0fb33f89bbecf4795157448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ffa8002a575f2c7e36d6bb2fa1c2f561cd391681ff6bf8afa0156645066d77"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
