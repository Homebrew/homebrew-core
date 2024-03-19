class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/7b/68/6895065c86c65a9388eb760a43ea695ec5b9b1c98a9675a3bcd682dbe9c0/SCons-4.7.0.tar.gz"
  sha256 "d8b617f6610a73e46509de70dcf82f76861b79762ff602d546f4e80918ec81f3"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c6b94fba45b0c21d695110fa318c6a9b53b9fe71144f1bae9ee8c38b4c44ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82b89dd373acc68b7fb2f2a8e23a183dfcceba5582760b7783e0c31440d96a4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3dc25bcdcc86857b1b069ccb3194e8b0bceafa974c8711ee456abdca9c7208a"
    sha256 cellar: :any_skip_relocation, sonoma:         "91acae80219d74656874541767162f83b492ca76790a7f8f246c7fcb5a051039"
    sha256 cellar: :any_skip_relocation, ventura:        "a367a980297c34131ff5dcb51460e667d0e9f6b5eee65acdc12683d5f82e6bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "67257e1cfae102ffc07e641d70cf415e89a29cc64e0e832c51ea29af8f7e3b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c548747373fac9ebd731df2c791d7ecaa89ac60188c3aa09d55e0c8273596c4"
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
