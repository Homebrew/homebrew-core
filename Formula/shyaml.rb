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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd44bdde266597560427182e4b9d659b5e816453d3823afaad0de6e4871e117"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bd44bdde266597560427182e4b9d659b5e816453d3823afaad0de6e4871e117"
    sha256 cellar: :any_skip_relocation, monterey:       "97f94a0d59c81a8dd508c5e30ab09c308933964072872b0f8a042f392b2dbd5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "97f94a0d59c81a8dd508c5e30ab09c308933964072872b0f8a042f392b2dbd5c"
    sha256 cellar: :any_skip_relocation, catalina:       "97f94a0d59c81a8dd508c5e30ab09c308933964072872b0f8a042f392b2dbd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c55cf325106d8d40eaa08d186f657a812103d0b20fa19386d624fdd5c00bd4"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

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
