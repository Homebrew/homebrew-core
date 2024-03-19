class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/1e/2b/267cd091c656738fd7fb2f60d86898698c5431c0565f87917f8eb6abb753/trash-cli-0.23.11.10.tar.gz"
  sha256 "606ca808cd2e285820874bb8b4287212485de6b01959e448f92ebad3eaa4cef8"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "861959d5bbeba99e1280e20e69895f4cd45a185f3caa5f74e58a94614cf1a1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c43b5fc636242a344d958ca6a448d28b53ef9eeea541b1d51339424f4ca927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6e82fbfd39d929b3770ad713806b9be14568ecd8d1764d9100e8f6b5e3973d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5999c3042b9832054d21b0ccd1a1576e8668651c811ca9d07215643c11f90e0"
    sha256 cellar: :any_skip_relocation, ventura:        "34909b21a3029bfbb7c4ed74368856cf2db6cc2566d4fcad8bd520414bd3fe50"
    sha256 cellar: :any_skip_relocation, monterey:       "c03f3a2966658b1f5e02db27a39799b079855ee41c425436dde041a47f4f3131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82fa2f28a74fb3adfeb129ca5f838581dc06035788eaa8616e63fd89a193b1df"
  end

  depends_on "python@3.12"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
