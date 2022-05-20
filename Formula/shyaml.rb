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
    sha256 cellar: :any,                 arm64_monterey: "9788455326ea60f6347e6b7f950505b265aa96a197aee6c7380b449cdc3d7605"
    sha256 cellar: :any,                 arm64_big_sur:  "f875eb7002238f8636d85d8f6b3d5f64a0413c65f214b38d4efc2ac6dfa01b86"
    sha256 cellar: :any,                 monterey:       "cbbc62f2a469c658c08693ad8c90e519404e63a7467e81ab81e033096c2e8838"
    sha256 cellar: :any,                 big_sur:        "8e1c547e77addf803029fa7655a74f9f77ec3bdb9745631f46e08d7144a9fe48"
    sha256 cellar: :any,                 catalina:       "a99ac074fcf20e8c16f532dc3a5f89016cb045c2c71695ad42a802fdd018c705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3df94c12dc3917a52251264f28a4ab8e24bf1e243412b231693f36df62368d"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
