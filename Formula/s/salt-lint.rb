class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_tahoe:   "b606364c1a88093ebede5792fbd635b2341e88be4445bcdd3df4e5a86311bf72"
    sha256 cellar: :any,                 arm64_sequoia: "66e97e657e2f63d010ae22eca72be97f2852ff05c766875d979bed46d6c3a97a"
    sha256 cellar: :any,                 arm64_sonoma:  "8a714043bf26e236545a4c7b14a80618eb192757176b632678e8c3077040798f"
    sha256 cellar: :any,                 sonoma:        "c9f93105dae3ecb41c3536a5e462027915159283114ee79ce154e52eb6e491bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce0ed5262eb581bff74a9aadd2c4bb5f83f172d4c1a68d2c9685893aca0785e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3406be26bba9f19eeda9236f526a0eba97654495365e78dc2226ce5910f8bcb3"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
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
