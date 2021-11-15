class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/b9/59/7e6873fa73a476de053041d26d112b65d7e1e480b88a93b4baa77197bd04/shyaml-0.6.2.tar.gz"
  sha256 "696e94f1c49d496efa58e09b49c099f5ebba7e24b5abe334f15e9759740b7fd0"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/0k/shyaml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9758d2528c7868f37da2288575d41fedd68ef58a3b94e67ef1d5f0d4887d64f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9758d2528c7868f37da2288575d41fedd68ef58a3b94e67ef1d5f0d4887d64f0"
    sha256 cellar: :any_skip_relocation, monterey:       "8929db2d65a2d8654dd55b1ea5baaa619a730887517d31097e99d47b2ec0bacd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8929db2d65a2d8654dd55b1ea5baaa619a730887517d31097e99d47b2ec0bacd"
    sha256 cellar: :any_skip_relocation, catalina:       "8929db2d65a2d8654dd55b1ea5baaa619a730887517d31097e99d47b2ec0bacd"
    sha256 cellar: :any_skip_relocation, mojave:         "8929db2d65a2d8654dd55b1ea5baaa619a730887517d31097e99d47b2ec0bacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72387bb319b260214648632cd847356ca753e0193d8c7a0ce3f53ac5eed3f86"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~EOS
      key: val
      arr:
        - 1st
        - 2nd
    EOS
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end
