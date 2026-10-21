class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
  sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ede13336416c7c79617fa6aad7136a8fe3c8888b6c878917a34d5efe9d1e6160"
    sha256 cellar: :any, arm64_tahoe:       "32b829bff17400cbfb651af60e2280241dbd4371122f264b3796fa7215a0ba00"
    sha256 cellar: :any, arm64_sequoia:     "f75d86b93af557ec7d779000e25dee33e4c61478adaa587f2be617ca7d520bc4"
    sha256 cellar: :any, arm64_linux:       "6ec37a0e9b7fe300fb4f4c28aca2a75b2bd547ee293b7842762d8a28357123a4"
    sha256 cellar: :any, x86_64_linux:      "d50c0ff0022793c35ad5bcb96f2d1c64db57ca0cc901679151623b941d414f8e"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~YAML
      ---
      foo: bar: gee
    YAML
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    assert_empty shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
