class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/66/3e/4d08c5903b2c0c70cad583c170cc4a663fc6a61e2ad00b711fcda61358cd/vulture-2.16.tar.gz"
  sha256 "f8d9f6e2af03011664a3c6c240c9765b3f392917d3135fddca6d6a68d359f717"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4969db78c39c58d4a158aa8efd5ab19020c52b1e2536919c2b3c65929c50f18"
  end

  depends_on "python@3.14"

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
