class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://files.pythonhosted.org/packages/22/e1/df78c47d98070228bc1589df6aa2b2c7ae1d4b35f9312dbb2d7a122a0f19/ydiff-1.3.tar.gz"
  sha256 "8a2e84588ef31d3e525700fa964b1f9aab61f0c9c46281e05341a56e01dcd7b8"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8837c75ec79bbf951b76ac5b0013a6b7c275d0763b871f92581e81741857bbcd"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
