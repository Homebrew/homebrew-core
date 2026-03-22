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
    rebuild 6
    sha256 cellar: :any,                 arm64_tahoe:   "84f85648e8f7a9e3b6d23bc774b4035e68987ec320afa9a26681a34984f54606"
    sha256 cellar: :any,                 arm64_sequoia: "12253411fc0733aeb8580e76eb8c498e968d5fbf26fc2c9ee0a969ed3d81f896"
    sha256 cellar: :any,                 arm64_sonoma:  "8bc9980e56a28c35bb9e73b018296a99a2d327d00886079362e13074516bcf6c"
    sha256 cellar: :any,                 sonoma:        "53720f2b4c3d835c02119ee91e3108b5aa9adda2ec3fda2964d672a8c42f11ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06fdc63c06d8747e6865af44a5e5b93a6c69688b03957c5d2e5f8bd77f98d52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94fa46b2c7b21233b659a07743538eca11873d6787515cf74b98b8632e014abf"
  end

  # Last release in 2020, needs patch to build with modern setuptools
  deprecate! date: "2025-10-26", because: :unmaintained, replacement_formula: "yq"

  depends_on "libyaml"
  depends_on "python@3.14"

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
