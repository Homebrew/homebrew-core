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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c0a29a8a83f03d4fb8f04cee9932cc696308b9ceec4590cfb4f30caa8be9c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c0a29a8a83f03d4fb8f04cee9932cc696308b9ceec4590cfb4f30caa8be9c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97c0a29a8a83f03d4fb8f04cee9932cc696308b9ceec4590cfb4f30caa8be9c8"
    sha256 cellar: :any_skip_relocation, ventura:        "083e980a2579d509ae832e64e27b676d32b15b4ab8c5b85ac381f9a116e5c706"
    sha256 cellar: :any_skip_relocation, monterey:       "083e980a2579d509ae832e64e27b676d32b15b4ab8c5b85ac381f9a116e5c706"
    sha256 cellar: :any_skip_relocation, big_sur:        "083e980a2579d509ae832e64e27b676d32b15b4ab8c5b85ac381f9a116e5c706"
    sha256 cellar: :any_skip_relocation, catalina:       "083e980a2579d509ae832e64e27b676d32b15b4ab8c5b85ac381f9a116e5c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9692d49037767d99705665957e0b26aa3a9f5619b06ed57d09a63aa4c176c510"
  end

  depends_on "python@3.11"
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
