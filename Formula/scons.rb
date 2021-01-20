class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/07/81/d73f00bd5bfcd8a654b250a64c03e445beb8d382f3d2d2fda2b49e413c91/SCons-4.1.0.tar.gz"
  mirror "https://downloads.sourceforge.net/project/scons/scons/4.1.0/scons-4.1.0.tar.gz"
  sha256 "accb8035be2c9cfbab06471286eaeff86a10037a8064cf4ef4c3df04ea5a7387"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5ebef89fc0bc3ac4b510504e24368a44f926771e61dfa6adb2b0ac29f92e66d7" => :big_sur
    sha256 "25a6b0372a45596d23dfedd7529b41f57c966eb63b08ae1589298f182e25f5f9" => :arm64_big_sur
    sha256 "c5051503085ee71b2ca039c0c30d16a1aceb77fd2603735b3e37571b936b9158" => :catalina
    sha256 "b3fbbbf21fc6198ba87770cc870aa98602a2cf76f2971fb054b7e7dafdcd191c" => :mojave
    sha256 "337031123eb8835112a41baec030df5d16fcd90944a827d9f9721dd64388d6ef" => :high_sierra
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
