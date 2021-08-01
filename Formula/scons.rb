class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/5e/f1/82e5d9c0621f116415526181610adf3f9b07ffca419620f4edfc41ef5237/SCons-4.2.0.tar.gz"
  sha256 "691893b63f38ad14295f5104661d55cb738ec6514421c6261323351c25432b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7b3af07e0b2686ab9413ec26839f9b965cd1a5ce7779a725e91157a236e7070"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f88d30ce5ca1988ef8e22b28893b8f2efcdbf66135cbb18e70cc19912360571"
    sha256 cellar: :any_skip_relocation, catalina:      "2ab0ded542c705c9cd7c84269035b08a6754844af4cd2580e1de5a55365af495"
    sha256 cellar: :any_skip_relocation, mojave:        "36d14af5663e63ce0b7a40f53c6824a5545b1f1ba2e4195e83dad0978cb54dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980c77d9a1f9887a71e49bf20e69837cd0a4e15b5425a24e4f1d0c6ac426aa72"
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
