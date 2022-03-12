class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/b7/d4/39e1239049061dcea566abfddf9ee8dedca56980f4fa74e3244ccff729ea/sqlite-utils-3.25.1.tar.gz"
  sha256 "df695f509a136e47e5ced2d4fc10e16c76ee3a45bae8e1a91cbba2c80285cbc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13154acc84882b6c6aa07097fcff176e7dd7e44ec06517b8acfa956228a53a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc831bb6e474c2994f2065d568a98d7c0274852468543afd64ff95ef06a82f95"
    sha256 cellar: :any_skip_relocation, monterey:       "72615d57423b898e9b2fa450539d8e8cdf41934ebadd122db0d2de9addfe201b"
    sha256 cellar: :any_skip_relocation, big_sur:        "25f4a85aad7fe22411828fe9e7b642754c94e469de4d065e29cdac5b7725c1c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f9492f758ee4164efecbbea4bd9b0daa593d2e1a7318ef4aeff26ca1033d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4611f2b878db970c4977abba960cc23098cdbb912453a044618f9228d1028f83"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
