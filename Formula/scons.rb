class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/be/d0/bf4e7003369c6d8a6e490741c54791c7918d9ef10b56aec201e76706f1d7/SCons-4.1.0.post1.tar.gz"
  sha256 "ecb062482b9d80319b56758c0341eb717735437f86a575bac3552804428bd73e"
  license "MIT"

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
