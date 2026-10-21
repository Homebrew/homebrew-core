class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/b9/59/7e6873fa73a476de053041d26d112b65d7e1e480b88a93b4baa77197bd04/shyaml-0.6.2.tar.gz"
  sha256 "696e94f1c49d496efa58e09b49c099f5ebba7e24b5abe334f15e9759740b7fd0"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/0k/shyaml.git", branch: "master"

  bottle do
    rebuild 7
    sha256 cellar: :any, arm64_golden_gate: "9ae8c668000d8e7533dd4d9b9e48fd5b92024f25749f680c45811e4818935715"
    sha256 cellar: :any, arm64_tahoe:       "113b6daed19d8f34cbeb793f290066781d77945a3810ae0549e47d9c0d1b7ded"
    sha256 cellar: :any, arm64_sequoia:     "2e54da490b82bc88dbb9ff3f2f9cf4f57ade4390b7e31d44d560193db98a2afe"
    sha256 cellar: :any, arm64_linux:       "3b76804447ca7db54c0fb5bc95c2c29670f7568d735d50654714cded341c7fc3"
    sha256 cellar: :any, x86_64_linux:      "5984d1fb37aa77106bd1058e4ad5a28c5e0741a11dc8c1c2f16577f1b72feefb"
  end

  # Last release in 2020, needs patch to build with modern setuptools
  deprecate! date: "2025-10-26", because: :unmaintained, replacement_formula: "yq"
  disable! date: "2026-10-26", because: :unmaintained, replacement_formula: "yq"

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    # Remove unneeded/broken d2to1: https://github.com/0k/shyaml/pull/67
    inreplace "setup.py", "setup_requires=['d2to1'],", "#setup_requires=['d2to1'],"
    inreplace "setup.cfg", "[entry_points]", "[options.entry_points]"
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~YAML
      key: val
      arr:
        - 1st
        - 2nd
    YAML
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end
