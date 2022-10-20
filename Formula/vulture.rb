class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/b9/18/e51a6e575047d19dbcd7394f05b2afa6191fe9ce30bd5bcfb3f850501e0c/vulture-2.6.tar.gz"
  sha256 "2515fa848181001dc8a73aba6a01a1a17406f5d372f24ec7f7191866f9f4997e"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f3c5caff61b92d1aa8f31ff34aed3bf4526d2c2e4bab1409b453b473c20e3c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "842d3da62ea17a600c26008460b4fb3d4e034b8e27d2140c6369ae1dc2c6504f"
    sha256 cellar: :any_skip_relocation, monterey:       "715bc22c1880197dd150ec5b3a2330aea6d3a80b997523008519a9fbe9accce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f23be8226174980a8c7c3e39dc8bc19a258a28e8303a639f7253611d793bab9"
    sha256 cellar: :any_skip_relocation, catalina:       "688c40b7a52b40d0b995f20d94ecfb1287f4290f582882058ccb536b9b0ac5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03836b9652b569b1f7537a7340f302903b156e4b1bad6886feae8e4653b8f3ac"
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
