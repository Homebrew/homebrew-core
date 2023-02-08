class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/5e/93/20ed28be32d01ac594cc3f78a797be5caf5e32157d85f374c675ce0782ad/salt-lint-0.9.1.tar.gz"
  sha256 "898afdb8af9b2e09ba1deb0fd62c1a94250ef4301cf531f59e6c0c0493309c60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da0b526506b37fa0eaa7de82830af5de532e5f774856b818f5b292b4b7fa38e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02bd28d1dd0aa195205cd5655e5651902f7c1e0ff4cab8c45921d63883f1eeb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8524598b64d3fd49701a98dcc483c034776b579a2c96422f5ad0a9d46632b27f"
    sha256 cellar: :any_skip_relocation, ventura:        "3042a1d9a3fe65962c2488b00a08dbe7141defd4f11147966d1988720e2b1f80"
    sha256 cellar: :any_skip_relocation, monterey:       "61f299ba3fa4ed095ad33ab53dd4a9da37f375d013c922f45441eb3a49d37e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c09182242226685923b180c697093ebe5e27dca0e1e502c2fab829ef85ec711c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e9a00859ee9f3aedf7fbe0cdd5c245cc0c8c254dd04dd47e9dbb0c56bc7e2a"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
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
    out = shell_output("#{bin}/salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
