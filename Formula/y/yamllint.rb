class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/da/06/d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63e/yamllint-1.35.1.tar.gz"
  sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f4c04876473720910f72e135311c05d3fefe3208bba7d90e7904cbbc2f154051"
    sha256 cellar: :any,                 arm64_ventura:  "55c913a5745760a8c12f537a3c67fa1e97dd8dbc8e8ceb4ef7bc87d27b116279"
    sha256 cellar: :any,                 arm64_monterey: "2698561d2192e10a5566a2168f6ec3ded2bc5416970967b3667408d144b6e497"
    sha256 cellar: :any,                 sonoma:         "b7b45b6cef591f8f02529e510315543830b33e4de4827fbffb1deed4c8e1c30c"
    sha256 cellar: :any,                 ventura:        "9b3b376d46761939812fb46be383f62dda5370417a6968bef9043ea701dd8be9"
    sha256 cellar: :any,                 monterey:       "abfd6d24311132e574b45598a59b44f07d48dc35f5e383eaad45f793fd49fc04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a1c2f2e7b0f719576acf927daf06638605e873bc72ccc862ca3e0bf28faf64"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
