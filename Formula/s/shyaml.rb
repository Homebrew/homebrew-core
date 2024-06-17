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
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "dfef640dec7d7feda0631dee64cecf64cbfa4f652fb904968aeb3559689df56d"
    sha256 cellar: :any,                 arm64_ventura:  "ca3e01a14e019cb5631b9e2650389b9dce17e669a030dec0f7e76d2a4229cb57"
    sha256 cellar: :any,                 arm64_monterey: "4af452f5d5c74a91d59137836d1ba084fb9ec74a42deffe6adfa347eb8e96bb7"
    sha256 cellar: :any,                 sonoma:         "6f01fcbb83d7129550d9edf349dfbca663922bed9a3658c92c34632abad19661"
    sha256 cellar: :any,                 ventura:        "60ea04a3903772b63ef876d1d20d44f954f189abf7187a1373dd25917eb6919e"
    sha256 cellar: :any,                 monterey:       "9ad3c28af300bbcac8dc4e62dcffee9e91405cc6b2097efebc7267975b8998ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c85847600b5161298d5cb8df0466940912c75b3f11ee8fa4d81bd5078a89db7"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    # Remove unneeded/broken d2to1: https://github.com/0k/shyaml/pull/67
    inreplace "setup.py", "setup_requires=['d2to1'],", "#setup_requires=['d2to1'],"
    inreplace "setup.cfg", "[entry_points]", "[options.entry_points]"
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
