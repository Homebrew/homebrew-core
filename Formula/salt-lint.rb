class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e8/3c/71fad4e9fde031938462e1b79ad7675b62970fe16913df60eb5e70f2807d/salt-lint-0.8.0.tar.gz"
  sha256 "c0b214dcf021bd72f19f47ee6752cfef11f9cce9b5c4df0711f9066cc4e934a1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec23101aba98daf6e4c4f5fe3ccfa52a400de11ab2346f528c3991e53b97066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ec23101aba98daf6e4c4f5fe3ccfa52a400de11ab2346f528c3991e53b97066"
    sha256 cellar: :any_skip_relocation, monterey:       "8020c9b974a0b20c89b78163974095eef75126f9849f0f1a7e66541dca694863"
    sha256 cellar: :any_skip_relocation, big_sur:        "8020c9b974a0b20c89b78163974095eef75126f9849f0f1a7e66541dca694863"
    sha256 cellar: :any_skip_relocation, catalina:       "8020c9b974a0b20c89b78163974095eef75126f9849f0f1a7e66541dca694863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db2b9be00685f954c606b58f19777d3b1ad4c23b3bacf609a3549c6174b3f954"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
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
