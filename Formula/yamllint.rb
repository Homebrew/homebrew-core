class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/c8/82/4cd3ec8f98d821e7cc7ef504add450623d5c86b656faf65e9b0cc46f4be6/yamllint-1.28.0.tar.gz"
  sha256 "9e3d8ddd16d0583214c5fdffe806c9344086721f107435f68bad990e5a88826b"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58d67664eca5c91e1072fa00941491a9af5e6d07a99c422ef022cd033f7f6b16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e734080f9ef58b1e5b324cd5a421601519a181b466df093f2890252c8c32a61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "652aac84b2465cacd8148561d7448986c73df6b512b7aed9e351e4c7c7f8be60"
    sha256 cellar: :any_skip_relocation, ventura:        "3737f04fc04a1a689e140055a09125d10d7e138eb2b1f9ebbab90e5f1917b5d1"
    sha256 cellar: :any_skip_relocation, monterey:       "13e33c28193edf6781c3cf33e992c3b4e32cd63275b76678b634e6cdd06eb46e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad293f400a905f2543160b822dbe7ef35fc57cc311af01cf6e42323649ce6ea3"
    sha256 cellar: :any_skip_relocation, catalina:       "ca41159b0a775a9352295d2232520385baf10edbbdcf422bd1bc5b498efd1173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f973b37601f6e98ad1b30d03c81f6accf8155da0feb0c146c2b3b544e6a72fe5"
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
