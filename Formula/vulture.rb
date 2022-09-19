class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/b9/18/e51a6e575047d19dbcd7394f05b2afa6191fe9ce30bd5bcfb3f850501e0c/vulture-2.6.tar.gz"
  sha256 "2515fa848181001dc8a73aba6a01a1a17406f5d372f24ec7f7191866f9f4997e"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe1f35cae3139ca9f0e0c8ac6ac04ebf074b03ebd6d7e02435250b219c3b2fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4fc674f6166ea85e48837901df275396a4fc843db29dd574b1d0364efe879ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ea2b19a5b86ff983f8a218286129ebb3d634f0c580965da10c937617dce9b40a"
    sha256 cellar: :any_skip_relocation, big_sur:        "87d21d855614f78513380b5a38d4e088b959c6fbb857200816bf6eabc7bf54d9"
    sha256 cellar: :any_skip_relocation, catalina:       "f083e74e7a17bce54810190882125ae2ab32180899b5a971d5d8a62a33f7e254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "725a4de9b0125f496707cc250c1e2fe0e56e26ebc87edff5d7ecbf93d574229f"
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
