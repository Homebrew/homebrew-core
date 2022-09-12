class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/c8/82/4cd3ec8f98d821e7cc7ef504add450623d5c86b656faf65e9b0cc46f4be6/yamllint-1.28.0.tar.gz"
  sha256 "9e3d8ddd16d0583214c5fdffe806c9344086721f107435f68bad990e5a88826b"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67777c3418b76852325cf34ffa724992f88fa5263f157a2b2a8e06960a377d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c67777c3418b76852325cf34ffa724992f88fa5263f157a2b2a8e06960a377d1"
    sha256 cellar: :any_skip_relocation, monterey:       "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, catalina:       "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d03eed79e2f94d57cfd6007acff2aa09902dc283680a0d0e8c8e49f7a526edb2"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
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
