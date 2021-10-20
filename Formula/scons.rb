class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/5e/f1/82e5d9c0621f116415526181610adf3f9b07ffca419620f4edfc41ef5237/SCons-4.2.0.tar.gz"
  sha256 "691893b63f38ad14295f5104661d55cb738ec6514421c6261323351c25432b0a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2d4ba2cf999877f61995e55235552997d2236d66d69d29d9e93059876cf7656"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, catalina:      "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, mojave:        "a5e7cc6c2d5dc05d1cd02ca3927425ccaf583cbbe2a8d97760bfa45d8479bd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea01cfe768ad1e59ec0c1dc6e777c6ab36fb821ca553bf5e54d9f74dd35b07f"
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
