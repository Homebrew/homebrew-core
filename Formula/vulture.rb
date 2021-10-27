class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/30/8b/bf4765866521da744ca081f09184657c0dc4fd8ee910a2fd1043d2c7cd6e/vulture-2.3.tar.gz"
  sha256 "03d5a62bcbe9ceb9a9b0575f42d71a2d414070229f2e6f95fa6e7c71aaaed967"
  license "MIT"
  revision 1
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8df33d60a71db6f9cf50d1eb6ba88cb809b8f58971a3993a3e0695fe2d26c94b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15943088313f0f1636786938dba0625f4826370e556585b48d2d154a00a9a805"
    sha256 cellar: :any_skip_relocation, monterey:       "4947fe3d214639b74461fd582c0262044b208462cc889d4ebfc863927dcbe30f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede0a34d82eda81423282e75f1fa99d3b86b16b78cb2961928f6a6b3bfb77341"
    sha256 cellar: :any_skip_relocation, catalina:       "480319c78f46a25a94c7e993bc88102d0569895403a06c370551bfc2455c0e95"
    sha256 cellar: :any_skip_relocation, mojave:         "c3e6dffc1ca081ce496cf44351a836a9a1fc6d0984897efc7efeae4d8ae52696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c69939c42b00da8c3f7688cd7a4cdec39631299492f7c30b051c9d19f1f97b2"
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
