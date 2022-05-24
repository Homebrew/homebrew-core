class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e8/3c/71fad4e9fde031938462e1b79ad7675b62970fe16913df60eb5e70f2807d/salt-lint-0.8.0.tar.gz"
  sha256 "c0b214dcf021bd72f19f47ee6752cfef11f9cce9b5c4df0711f9066cc4e934a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964a0f02571d42456a49e09084f75a3b090d5645f531996f9017e60af5322ca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18cb846fbbe635871412c188b4dad2d5c762591c318ac474515f40e1d4718e7"
    sha256 cellar: :any_skip_relocation, monterey:       "7d39c07a2ef7d773021b00361df48ed58a427f4beaf69c8581611a0fa518dc4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e38a29094410d7174a601a95e06f0f03804f29f668bdde7eaac4fb983777a76e"
    sha256 cellar: :any_skip_relocation, catalina:       "eb2c0c1dd65e120575a0e7fd0240bd9276da4ecbb3f30a80514ee19e8579f4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7095f4b7a420845d908dd64fd6748faa10db2f85d5fce66b79ffd62d807afefe"
  end

  depends_on "python@3.10"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
