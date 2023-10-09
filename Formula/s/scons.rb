class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/e6/a4/c7a1fb8e60067fe4eb5f4bfd13ce9f51bec963dd9a5c50321d8a20b7a3f2/SCons-4.5.2.tar.gz"
  sha256 "813360b2bce476bc9cc12a0f3a22d46ce520796b352557202cb07d3e402f5458"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e038a0a50bf360903bf9fbca26bca748db4fbc648bb37048e748a7e2f9f58fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6eb1831587fbe82f157ede1c0c0692aac00ec0e5682316691588397cea3b8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05823bb9769bedc72562c7155e567941bee8e1996790b304abbd8adf559aa459"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b33ce8ab11c8dc58627a8a9e4a344ed94676da5835e73b6d7c89342b79e39d"
    sha256 cellar: :any_skip_relocation, ventura:        "cc154f96a48e3433e62fd10df7e120ad578af6bad14b5752aa07b7e7fb584656"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3a08fae6e0cd9a3d9b62c7e4c054f475b691131bf7eb385b032dff88e8de47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3761e947e8602d9bb75833f09ca4c08bd64b7d7048d374dd5c96749993d24c"
  end

  depends_on "python@3.12"

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
