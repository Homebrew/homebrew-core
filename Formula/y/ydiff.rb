class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://files.pythonhosted.org/packages/22/e1/df78c47d98070228bc1589df6aa2b2c7ae1d4b35f9312dbb2d7a122a0f19/ydiff-1.3.tar.gz"
  sha256 "8a2e84588ef31d3e525700fa964b1f9aab61f0c9c46281e05341a56e01dcd7b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, ventura:        "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, monterey:       "71785c20c88c11d4ad640dc8b166f23daa74a95d95c274ab5c0028a0f42499a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d5d05030eb906207ab27c47e708de68ee5b5a037e86b7f7300cafc46a69071"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
