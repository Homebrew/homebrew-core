class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/be/d0/bf4e7003369c6d8a6e490741c54791c7918d9ef10b56aec201e76706f1d7/SCons-4.1.0.post1.tar.gz"
  sha256 "ecb062482b9d80319b56758c0341eb717735437f86a575bac3552804428bd73e"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7b3af07e0b2686ab9413ec26839f9b965cd1a5ce7779a725e91157a236e7070"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f88d30ce5ca1988ef8e22b28893b8f2efcdbf66135cbb18e70cc19912360571"
    sha256 cellar: :any_skip_relocation, catalina:      "2ab0ded542c705c9cd7c84269035b08a6754844af4cd2580e1de5a55365af495"
    sha256 cellar: :any_skip_relocation, mojave:        "36d14af5663e63ce0b7a40f53c6824a5545b1f1ba2e4195e83dad0978cb54dc5"
  end

  depends_on "python@3.9"

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
