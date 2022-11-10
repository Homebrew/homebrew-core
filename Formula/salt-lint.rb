class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e8/3c/71fad4e9fde031938462e1b79ad7675b62970fe16913df60eb5e70f2807d/salt-lint-0.8.0.tar.gz"
  sha256 "c0b214dcf021bd72f19f47ee6752cfef11f9cce9b5c4df0711f9066cc4e934a1"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87fc6f52e39cca360c96a70a329080dae9beed83737c8b6f9127962bde43ae25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5854dd0330baaf0f6d0d26fe4e0910932164de550fc5759b1d2832f6aa646a51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f38d3c5d28634fb1543ba4ba6f61c1e97719e2bed569132968d532260cbf44"
    sha256 cellar: :any_skip_relocation, monterey:       "23df453884270f756913358f4b7e1d9fc6b08a92e72d180a9646060e0458376e"
    sha256 cellar: :any_skip_relocation, big_sur:        "05150cd861ee2d091d7a006e2026adec3a08c6d4f0b35515916ee911c9853acb"
    sha256 cellar: :any_skip_relocation, catalina:       "74394670e09ff7757149be51d66049b0d0b3d8cb2f2dfe3c8fe2cbb9f517911f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68913a999bbfa7d99438aa023989b8d453e8f32ebba446075261372bf98e06d6"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sls").write <<~EOS
      /tmp/testfile:
        file.managed:
            - source: salt://{{unspaced_var}}/example
    EOS
    out = shell_output("salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
