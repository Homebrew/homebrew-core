class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://salt-lint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 6
    sha256 cellar: :any, arm64_golden_gate: "a977f3ded9ade7efab26c7cc9d6c7ff3a1981861c1024ba4370e2d5dfb8ea876"
    sha256 cellar: :any, arm64_tahoe:       "463ca6e44950c80415077f7680c584957f1cc2ca113db9eb804aff0058361ae8"
    sha256 cellar: :any, arm64_sequoia:     "3292bb3838f275d9786b9387d70b240106422ef46ba8ad94da82743857ddc89a"
    sha256 cellar: :any, arm64_linux:       "fc4424e8b985981d483436d2591dd17c67212b8074401c96b3017ef5b76bd67b"
    sha256 cellar: :any, x86_64_linux:      "9b50c064b8d76309a2b04ebe8aea65cf7fa8d191764d9021ac5d0964db0dbf40"
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
    (testpath/"test.sls").write <<~YAML
      /tmp/testfile:
        file.managed:
            - source: salt://{{unspaced_var}}/example
    YAML
    out = shell_output("#{bin}/salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
