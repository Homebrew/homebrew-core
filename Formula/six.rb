class Six < Formula
  include Language::Python::Virtualenv

  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
  sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  license "MIT"

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
