class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "9afbe8489e6dfeb203516d6d2718bc2e85345a827e7398ee4b20bf3e496398d7"
    sha256 cellar: :any,                 arm64_ventura:  "911415031fbc3be4a8af2ca1fe496318852a27ee1c79f0c9e7b3a29c2a7e8e92"
    sha256 cellar: :any,                 arm64_monterey: "4493b79c24997b405f581ebf42d563688562fd3036f8689f8c5206f5f77d9a36"
    sha256 cellar: :any,                 sonoma:         "cf61c07c497d94ffe41ffe80b0f71bdee68b74e35ba48594c1824123c16aa6ea"
    sha256 cellar: :any,                 ventura:        "89e6e875355e67313d9c90791d8878045c364a04b8814ae8a4e2dae43d89b515"
    sha256 cellar: :any,                 monterey:       "565749cea976e90f01e04b9638fca31205bcd8e466e29f4bd9a74829a52fbd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56ab6bc3208c4ae59dce7fdf26b7c6b876d94516359752a4122960a14b3096b"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
