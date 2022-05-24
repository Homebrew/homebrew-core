class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/64/a1/9dc5c5e43b3d1b1832da34c8ae7b239a8f2847c33509fa0eb011fd8bc1ad/SCons-4.3.0.tar.gz"
  sha256 "d47081587e3675cc168f1f54f0d74a69b328a2fc90ec4feb85f728677419b879"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddbf863043a23a4b42331c2de6ca71bbfdd7a12979a4c43f65694106745d3cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddbf863043a23a4b42331c2de6ca71bbfdd7a12979a4c43f65694106745d3cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "a5d0c147ee550cae094922ce5e46bd0eecb978757ee1131677a233c423c9b909"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5d0c147ee550cae094922ce5e46bd0eecb978757ee1131677a233c423c9b909"
    sha256 cellar: :any_skip_relocation, catalina:       "a5d0c147ee550cae094922ce5e46bd0eecb978757ee1131677a233c423c9b909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf0cd49fe6d92410f0f77186223735b224dc6ddf82c877a02e380a9612f2898"
  end

  depends_on "python@3.10"

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
