class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/7b/68/6895065c86c65a9388eb760a43ea695ec5b9b1c98a9675a3bcd682dbe9c0/SCons-4.7.0.tar.gz"
  sha256 "d8b617f6610a73e46509de70dcf82f76861b79762ff602d546f4e80918ec81f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95120f2bfed80d992a7f8f8b24e3b30461f5174a6b9a7c24a5722c6dc34eb760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95120f2bfed80d992a7f8f8b24e3b30461f5174a6b9a7c24a5722c6dc34eb760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95120f2bfed80d992a7f8f8b24e3b30461f5174a6b9a7c24a5722c6dc34eb760"
    sha256 cellar: :any_skip_relocation, sonoma:         "a896b0c7638102ad279bc7f80b0e533e5fa00bf458f7913dc534d7450b454222"
    sha256 cellar: :any_skip_relocation, ventura:        "a896b0c7638102ad279bc7f80b0e533e5fa00bf458f7913dc534d7450b454222"
    sha256 cellar: :any_skip_relocation, monterey:       "a896b0c7638102ad279bc7f80b0e533e5fa00bf458f7913dc534d7450b454222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "653548364415711953a4bb8283cd09bf087b2d46ed9ed2aa298eeaf3b62d3ae9"
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
