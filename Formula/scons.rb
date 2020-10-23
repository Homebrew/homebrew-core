class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/ae/a4/2eb8d05b0ac9e168e8ff0681624c123a123c743487e528757c68ea995d20/SCons-4.0.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/scons/scons/4.0.1/scons-4.0.1.tar.gz"
  sha256 "722ed104b5c624ecdc89bd4e02b094d2b14d99d47b5d0501961e47f579a2007c"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
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
