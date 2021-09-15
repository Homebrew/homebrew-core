class Six < Formula
  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
  sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02ff012017a8eec787fccf3ae46c45b6681faec6a2f2160a5ff15aafb5af0894"
    sha256 cellar: :any_skip_relocation, big_sur:       "6068e58ff59ea70f491671ad3257b129ed7d5b90a5c678348c3dfdaa14953cdd"
    sha256 cellar: :any_skip_relocation, catalina:      "6068e58ff59ea70f491671ad3257b129ed7d5b90a5c678348c3dfdaa14953cdd"
    sha256 cellar: :any_skip_relocation, mojave:        "6068e58ff59ea70f491671ad3257b129ed7d5b90a5c678348c3dfdaa14953cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee4622aebde5a4458f7fb814e9d91b591318c1ccd78f1657c3ae8e6dc047dcd"
  end

  depends_on "python@3.7" => [:build, :test] unless Hardware::CPU.arm?
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def install
    deps.map(&:to_formula).each do |python|
      system python.opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    deps.map(&:to_formula).each do |python|
      system python.opt_bin/"python3", "-c", <<~EOS
        import six
        assert not six.PY2
        assert six.PY3
      EOS
    end
  end
end
