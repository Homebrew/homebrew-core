class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/30/8b/bf4765866521da744ca081f09184657c0dc4fd8ee910a2fd1043d2c7cd6e/vulture-2.3.tar.gz"
  sha256 "03d5a62bcbe9ceb9a9b0575f42d71a2d414070229f2e6f95fa6e7c71aaaed967"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4f0c8d4d327b6d8687ef63b370a82332a25cea64be3eea8a55e20508d2072d2" => :big_sur
    sha256 "5c98aa924262650ff457d153e7b0452a22d8a6b69543bc4712832728837af256" => :arm64_big_sur
    sha256 "b5e8ebd31bc7aee0bd3c547db9e49d6e91af523213488bdb99ac6435c5404cf9" => :catalina
    sha256 "0c6278066d30cedf4c077cb351c750d295ba566a32107580243820970d3f787b" => :mojave
  end

  depends_on "python@3.9"

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
