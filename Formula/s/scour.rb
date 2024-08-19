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
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0220221dc5ee13694cc11efe36a4d1a6c7188b5c5f18c08045017380a8d77cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f659e358bec5d2c4801d75c5feea350cf9abe74f071ef9fbe267a3fcf7a478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bb6f0e2b7d8b957d0f1395a73053a3657a1baffa16e8910793616515596a04"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a588f0d41429d6c01c97dd8a47e991635d8f9905026699b9cedf2e4565775ce"
    sha256 cellar: :any_skip_relocation, ventura:        "7f99b32f82a77ad86dca83b6bc07bea7413799209c985ecb5a060c8ef47d2dc2"
    sha256 cellar: :any_skip_relocation, monterey:       "c96adfc46d9714759af1d099d5df7adc31d9692a5004d72885b817150d5eefbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30bf1e3a14c6bd8187417b13419af1e29297226b875ff409d873bdd356839147"
  end

  depends_on "python@3.12"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
