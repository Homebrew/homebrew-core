class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/5e/93/20ed28be32d01ac594cc3f78a797be5caf5e32157d85f374c675ce0782ad/salt-lint-0.9.1.tar.gz"
  sha256 "898afdb8af9b2e09ba1deb0fd62c1a94250ef4301cf531f59e6c0c0493309c60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b6321fc843c4ad8b1cf1ded5b174d12f435970dd4c35398db8815bb5ce6a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad129291f8090fe9c3e7b5f032ca0beaaa6365acafa41bcb7c02ef4a205f0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803b9b71ebdc062cd2f6916b8708548c9347bdf14b94b0e357571498907273e9"
    sha256 cellar: :any_skip_relocation, ventura:        "e5414f3e2cc389b93e37aa15ae2f934d182df89f09fba7de95477619a4248fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "1604578e3177842b5377be55e8e86fb119f12983491db50d6bf857594be15993"
    sha256 cellar: :any_skip_relocation, big_sur:        "39a5fcb90a5b1d5a9512b33c08114c2df4f5bb82790bd395bd7d41e829a22a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882fbe46b0001488b0aeacfb804ef1f2906db20e1490d6751f25348749aa7ab7"
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
    out = shell_output("salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
