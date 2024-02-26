class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/32/40/2776a3356a0902cd3962031f0d4d6eae04c6f17ca1ded575435182094ceb/translate-toolkit-3.12.2.tar.gz"
  sha256 "acee42b816f7796809b9b4768693664f6bd19fb96eae3d8dfec0932fa8761706"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb131cecf4589b91ac1fcdc6be14f5d66bd90fb56ac971b6724fba791ff947d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05b1f19a6bd262565931827f65c0d30aa80682a6653c8768762373998cd922bb"
    sha256 cellar: :any,                 arm64_monterey: "b6e991acef5fe55b71ef072876ab7d0d96f334bf5b27e74c5d7634032e56eb25"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd17a8277f141f00e2e25910df358e587a02a768bca73c14ab0c5078f5ba8f21"
    sha256 cellar: :any_skip_relocation, ventura:        "70cc093935fd4fef86bc980d6e3f8b266e2ce5948bf6e9f550a198488ba08ea7"
    sha256 cellar: :any,                 monterey:       "0c7a959ec9e2a726f7a1863b1847c7ce6ad21c3af9aef90011924484cad8518d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44e7606aeb5b431ebca6bd4105bbea00811418a57729f0b619b4f66d206130f"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
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
