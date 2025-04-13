class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia: "fbb1958185be4aad5fea5c651fd3e8da21fca696c5d213693e4a81936a1feb2b"
    sha256 cellar: :any,                 arm64_sonoma:  "96d91986ed175ad3f73c892694470d516dd30faea4e1598cbacef169edb6fbd2"
    sha256 cellar: :any,                 arm64_ventura: "d00a3fb68390018c7e193fdb099fe1f0a72e8648d516fe94b59090a8c5e390ae"
    sha256 cellar: :any,                 sonoma:        "a31bcc4981feaa7a540453588c749780977bc6174b7ba19379718f7dc2382300"
    sha256 cellar: :any,                 ventura:       "c1e8dada94ff1d4651ca11b4683df66be17bd39e20a92d3b0bc262350202dadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03c55be989567573dc4ef049c3b8b97c740979f398c568b8e1ea018d42f42a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0debb92e71999b2e340eff50cf7ccd2712b4bf86289f6af1c77b0f574a84842d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
