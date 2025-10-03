class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/scour-project/scour.git", branch: "master"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "4c7cfe80210581f2cfa70a91583596326dfe0cd395679ab589d2af4f5e749f94"
  end

  depends_on "python@3.13"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_path_exists testpath/"scrubbed.svg"
  end
end
