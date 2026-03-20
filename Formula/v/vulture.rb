class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/59/c6/4f147b621b4c0899eb1770f98113334bb706ebd251ac2be979316b1985fa/vulture-2.15.tar.gz"
  sha256 "f9d8b4ce29c69950d323f21dceab4a4d6c694403dffbed7713c4691057e561fe"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d1edeca5bb6872316c5192168113e018618df78e161df627b260009c8b3eabc"
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
