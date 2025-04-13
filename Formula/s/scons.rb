class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c8/c1/30176c76c1ef723fab62e5cdb15d3c972427a146cb6f868748613d7b25af/scons-4.9.1.tar.gz"
  sha256 "bacac880ba2e86d6a156c116e2f8f2bfa82b257046f3ac2666c85c53c615c338"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0a81c5d96f6ac781416672b44e49febc790de4cf60a239485efb95b3d6cadce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a81c5d96f6ac781416672b44e49febc790de4cf60a239485efb95b3d6cadce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0a81c5d96f6ac781416672b44e49febc790de4cf60a239485efb95b3d6cadce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da09c0f0c4cec9bad1951ce49c3b37c51b3596639fa4c90b60745bcc81b8c55"
    sha256 cellar: :any_skip_relocation, ventura:       "6da09c0f0c4cec9bad1951ce49c3b37c51b3596639fa4c90b60745bcc81b8c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0a81c5d96f6ac781416672b44e49febc790de4cf60a239485efb95b3d6cadce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a81c5d96f6ac781416672b44e49febc790de4cf60a239485efb95b3d6cadce"
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
