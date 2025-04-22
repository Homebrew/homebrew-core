class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/0e/dd/784c53fc251a39e61d0ebf8456ab1ad09082d206e3ebdd0cc8e532df95b8/translate_toolkit-3.15.1.tar.gz"
  sha256 "3a66a96eb72febe0397c66f7e312dd966a21dd0017375fb9571a0245dc97f663"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7706fe04a633d3f7a39f01b2cfe03268ed55a122307b4b3f3aff9213e35e68f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a3ec89a1f690cc1fee04c8b25292ba70301095c50e01fc679d1eef834ddaa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "138e675c021c3e3724dda2344d8da33c535d3bbd57664c339358caa282d29434"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5cb0577213d0c4b8c128f79f2e4bcfeaaec20f25b1d68dbcca5b9a277cfc601"
    sha256 cellar: :any_skip_relocation, ventura:       "89d12d37efe6796a66280c76020d4218f80a076bc32b8ede2c01c14aacbd4183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "818915968e3b3bf1b493ed8d271924681b03dc0fac155ffed80efd804b8c92bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23b09e3c6e7c0933fab4964460866742ceb44dbac597d2f54c4f2d0874e5b9c"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
