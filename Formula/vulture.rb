class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/21/1e/843bc79daf4f46c13c56692c488722e3465a509331f3bb84bb314f9a6136/vulture-2.4.tar.gz"
  sha256 "819439294a76b4e0b8e08c70d75565a8ce3dc1f6e03558ed123a5f2bb737c0ea"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd4b99f4bdbd0d1a8b889095d088193e051f27c763a54b922203772d590bf6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30854fdc4aeb0e99e953e40edfb758f9b78a338330bc54902fe4f73f840fb1eb"
    sha256 cellar: :any_skip_relocation, monterey:       "1036ebfc82380aa4f36d9b7407cdd5072493909bc06ee8b05b8b48ef2c61c6fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa2fd5aa8af519ec76764f3e391bb116af3e7ca034ac88d0e6fb74c1361c9fbe"
    sha256 cellar: :any_skip_relocation, catalina:       "90c9ef1e889b77f1d09ab513fb1711adbe4274071e8a72c804bafe85e2c5da66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d493f44c7ec903b95b0082fa8a7dcf341210a474fad7d189b534943586f8e6a"
  end

  depends_on "python@3.10"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")
    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 1)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
