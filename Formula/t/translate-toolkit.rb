class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/7b/36/618e11497e18b74a8f2807594d17711ebe9a674aacf7c19624f17c8f3709/translate_toolkit-3.20.2.tar.gz"
  sha256 "786ed210b262b0a94388f3bc824fa5b586b141d99cdd7db293e02c44ba146e7a"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "495bc5e1a7f13c870f6bba891110b73cf5adab0c6dc63e5f5e2c6dc2f5d2cc76"
    sha256 cellar: :any, arm64_tahoe:       "0dd909e2479563ac52ad392f8f76f3946f15e3673b20831764ce0ffff6baf1c1"
    sha256 cellar: :any, arm64_sequoia:     "4f9bee581de00c5b65fd401b4fdf81b81dca5556d2b3abe296e1f21ebcca4987"
    sha256 cellar: :any, arm64_linux:       "1bb0aa1c14fa110b72f68f909d766a9c325c41f293a6ad76151eea87710fc689"
    sha256 cellar: :any, x86_64_linux:      "09115e4f61e620feb437584290a8740571601d9ecda605a7b7d4a845be5f6afa"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/76/ce/3ea1a212af193525f26dfe40f419d67b734c52b43dd5214839c214dbefbe/unicode_segmentation_rs-1.0.1.tar.gz"
    sha256 "9bd38cbd89338b5d16f8a029c37d4d5743e1c2c91602a1df860bb5661b8e8a0b"
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
