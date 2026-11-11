class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e7/ec/c4572b49fdb9246f0610b6efcc6169d331f650dfdf2670e1a96c756c468c/translate_toolkit-3.20.6.tar.gz"
  sha256 "232a2043c438a390fb911eb6b4124e01a983fa8f193e58c422e72cd34bac6a05"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dd07a6a76a01aff6ebe0cfbdbcefc2a8ae1f743a74ef0d7a2b050c4d850a9b73"
    sha256 cellar: :any, arm64_tahoe:       "909a18778465bba152872d4db2e649268c111445e68dd8ea4cb715f82992a42c"
    sha256 cellar: :any, arm64_sequoia:     "c8680ab8fe680b64698d9d72970eea0c7eea42dfb4bdd5046706aa85447b2451"
    sha256 cellar: :any, arm64_linux:       "fd9ae82a3fb0a1c4d591db905becada60f5c644fd30732e080f724063f204dca"
    sha256 cellar: :any, x86_64_linux:      "7fe6a961e995bb55bb63413cb4b0db96930204c4d94dd53e402c5799d46e9371"
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
