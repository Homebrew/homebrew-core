class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c8/c1/30176c76c1ef723fab62e5cdb15d3c972427a146cb6f868748613d7b25af/scons-4.9.1.tar.gz"
  sha256 "bacac880ba2e86d6a156c116e2f8f2bfa82b257046f3ac2666c85c53c615c338"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b11d27d96f9c7e04dd36c8f4b750c0da9c4c0f8a34c778cdb9154280cff8c1ff"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    C
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
