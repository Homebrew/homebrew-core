class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c6/63/3a87df61a5d8e1b2ba116f4889f3dbc2717ebe2e34c77b2d34e4e6b9deef/SCons-4.4.0.tar.gz"
  sha256 "7703c4e9d2200b4854a31800c1dbd4587e1fa86e75f58795c740bcfa7eca7eaa"
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
