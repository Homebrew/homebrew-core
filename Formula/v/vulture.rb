class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/1d/7d/e78586863119fe28741c347988f892301319ce05edd11dbe0b45b18cc3b9/vulture-2.13.tar.gz"
  sha256 "78248bf58f5eaffcc2ade306141ead73f437339950f80045dce7f8b078e5a1aa"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1d4b76fb15499a3b119a0733053daa2c5a4d660bc78b63708ae634b57dd1d34b"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
