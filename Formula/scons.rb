class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/64/a1/9dc5c5e43b3d1b1832da34c8ae7b239a8f2847c33509fa0eb011fd8bc1ad/SCons-4.3.0.tar.gz"
  sha256 "d47081587e3675cc168f1f54f0d74a69b328a2fc90ec4feb85f728677419b879"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d4ba2cf999877f61995e55235552997d2236d66d69d29d9e93059876cf7656"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2d4ba2cf999877f61995e55235552997d2236d66d69d29d9e93059876cf7656"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, catalina:       "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, mojave:         "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea01cfe768ad1e59ec0c1dc6e777c6ab36fb821ca553bf5e54d9f74dd35b07f"
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
