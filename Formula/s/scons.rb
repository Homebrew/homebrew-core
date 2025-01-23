class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/b9/76/a2c1293642f9a448f2d012cabf525be69ca5abf4af289bc0935ac1554ee8/scons-4.8.1.tar.gz"
  sha256 "5b641357904d2f56f7bfdbb37e165ab996b6143c948b9df0efc7305f54949daa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6381cb480ea7ce3bd6cffe6832e36823bbaf7035474af9413dc8cb19749b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6381cb480ea7ce3bd6cffe6832e36823bbaf7035474af9413dc8cb19749b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c6381cb480ea7ce3bd6cffe6832e36823bbaf7035474af9413dc8cb19749b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "39bd1514eddb34b2f55eb00626f57b1ae0af20c4fde64e3f3c6cccb41cee3e22"
    sha256 cellar: :any_skip_relocation, ventura:       "39bd1514eddb34b2f55eb00626f57b1ae0af20c4fde64e3f3c6cccb41cee3e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6381cb480ea7ce3bd6cffe6832e36823bbaf7035474af9413dc8cb19749b0a"
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
