class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/0b/60/07bfccf5eae1502272fca50cbba2f8262be752dba8203baefe477598f62b/vulture-2.2.tar.gz"
  sha256 "490085bb7fdea45d5d398ba2774ca18a825b47d034b79689c42071cbab7e84e4"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3d2a03fa3542b8e7fd9acf7f4f5e4135ad27b5238ffa34505ff59e091a36e88" => :big_sur
    sha256 "ca85d3256fecad7108d300f4e22e0a2868ae27de1aea09290d686cccfd029c94" => :arm64_big_sur
    sha256 "cbe063689773ed4f0f631c359603a53f803f312b98944e3718d21b9f7974bda7" => :catalina
    sha256 "87d1b12cb798f56a56f0c16bcd5af882ecf111a5a181655209da4cc60afd0d81" => :mojave
    sha256 "305fefa88f47886779dc6c377abba61134c4c045be7400227bc7b0b24d75c337" => :high_sierra
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
