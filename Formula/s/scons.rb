class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/ec/5c/cc835a17633de8b260ec1a6e527b5c57f4975cee5949f49e57ad4d5fab4b/scons-4.8.0.tar.gz"
  sha256 "2c7377ff6a22ca136c795ae3dc3d0824696e5478d1e4940f2af75659b0d45454"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, sonoma:         "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730c4f0fdd3340bbb9a7e83fffc60618002ed71cc2f0a0901e17923a18766528"
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
