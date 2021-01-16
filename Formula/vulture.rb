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
    sha256 "df182c80e85e8335d63ea45687c708e96d7e42512e5bcd8daaca59883f426b31" => :big_sur
    sha256 "7dfafa10624e2956fd6f25f52f70c01f03dd34035b017cd336c935355e7de9b4" => :arm64_big_sur
    sha256 "47d3cf2391879232cba7ebe175171d346a0f3f19087349931e5fdb4042e1407a" => :catalina
    sha256 "060ecf78a75366725e599887237ca5698d35619f8745a841c7c6e59884a46461" => :mojave
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
