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
    rebuild 5
    sha256 cellar: :any,                 arm64_sequoia: "74bc7e9c8716937a88a39c1ad327023297d5f1f55521507be77a43b712ef3d9d"
    sha256 cellar: :any,                 arm64_sonoma:  "e4b9e31f5026c754f694089a0059eb993905c85d0bbce454b7a0e7f552888dd8"
    sha256 cellar: :any,                 arm64_ventura: "4f7b53eccdb86bdc42971decbb322d3a969b2528f2e298953310d2f8ca230252"
    sha256 cellar: :any,                 sonoma:        "e3fe6328da696bafa084bba416ad7ca30b5f311ec4730a55d5a1fd22c65bad2d"
    sha256 cellar: :any,                 ventura:       "f2877c8235ebc0aeec10fc8b0ccd10d8578688b2b04737f8266a403c9985da46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee58b3aa018ac1608838d0622c45f4c19440b1eadbc7c037c292f995efc272ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a82e1b77d8ad4f34f75ee3f1876aeff1e1dfc6d90bb4602627f5d6c6b0d7107"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
