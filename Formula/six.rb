class Six < Formula
  include Language::Python::Virtualenv

  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
  sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33a1b6980a4636327e204a1d9a0cbf5c7c9286e56e3ba6b1226e63b93fc01fb9"
  end

  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import six
      assert not six.PY2
      assert six.PY3
    EOS
  end
end
