class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/91/ff/2c0bab6e1fcd837c52afd99a37e0cc16f2e1c970d313c3d4bc10b5c047f2/scons-4.10.0.tar.gz"
  sha256 "61e2fc42e0e2c750105d61f26cc1dfebcae9f4103d3dc0e9aeb373016b0d208c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5761c79c411a73e5e65e866bbefcf0c2b040ea14a75c1b607cbaec465ac7d2aa"
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
