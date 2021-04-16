class Six < Formula
  include Language::Python::Virtualenv

  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
  sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23e2fecb3df6d6b474a1bc65d1ba03d9512dd797be4d2fac1ccfd0f1f99499c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "269efcb8c4551c623dbeab039dc890174b6f6dc17a387cd7bb59e5646f32fb24"
    sha256 cellar: :any_skip_relocation, catalina:      "be23fc6cc8ad85469db1650f9fbf42cd57e537bbe431dfbdfd6e18bcddd45cbd"
    sha256 cellar: :any_skip_relocation, mojave:        "427c2793a3ba839d8546934b7c1f20d009b6c6e2cd1d703d33f3c0b943f2e904"
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
