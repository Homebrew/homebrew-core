class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/0a/73/21e21d5648e7d599c476816695fe31e8b059c2f2e0b99804cd5ca9366994/translate_toolkit-3.13.3.tar.gz"
  sha256 "5bd73841a0ae99dbb583489879a4fa742860b3faa75ef2bb9d4f06f9e3195d75"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d413c2354c8faab216f50231aa6170a7dc6515858af9bc932e136a500cdcd260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9786d03334a4f4357879f24765d787ee213a274ffbc9faea26e962a3ca7bbc1a"
    sha256 cellar: :any,                 arm64_monterey: "8204411692b5be7b04543e29af758369b3f9c1068c8a7b13ac7a42c2d18e8be5"
    sha256 cellar: :any_skip_relocation, sonoma:         "936829556efcdf8c24aaf5e395096f4ca199943ca88b0723faf365fd3a8a38dc"
    sha256 cellar: :any_skip_relocation, ventura:        "9d835f64c5dda808546dccceda04a11c858d3f482e11af085aa1f76ca57d9ac9"
    sha256 cellar: :any,                 monterey:       "a57eec73e2dfd589f86c519621e08b57068a8c1340265ee0b4292a6bea6c8553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69be23d9b3fd994880e7c1b1238abff2b4a941bbc8dfcaaec93c38391fa198d1"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
