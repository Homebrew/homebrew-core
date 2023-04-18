class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2cd0d7d476e651ba383c2fac5d342b6ff6cacd4c067d06d1ee532238ba9447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dab22268d03811a93cabfdf358bc0bfd13f3051b72317672bfd976eaaa110c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9524446bac5fa0e317fa7e46ecf0be18e1d2fbbc54a8e0eeccb2c39cfe4b03f7"
    sha256 cellar: :any_skip_relocation, ventura:        "f0a06c52e6a37db529743d9432a35f7893c77a1725084c26a85e482c22cb99d2"
    sha256 cellar: :any_skip_relocation, monterey:       "1cad246b52cda8bfe5504099ff779da5aa2076767d18a0c9b1c47557d8f0556e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8f74d038dd22849312195c816b2a56a75231ba046b0ddb485ed03d38651fb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13825dc04e6d3dbb7bde6189810da4d2258d9dcfbdff472aa69dc0cc8735fd6"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f4/8e/f91cffb32740b251cff04cad1e7cdd2c710582c735a01f56307316c148f2/pathspec-0.11.0.tar.gz"
    sha256 "64d338d4e0914e91c1792321e6907b5a593f1ab1851de7fc269557a21b30ebbc"
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
