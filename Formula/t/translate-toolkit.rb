class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/77/a6/75b9552f650a2f44fc9182317fe7f46e4091baae5f2f183b715e19f48749/translate_toolkit-3.19.12.tar.gz"
  sha256 "3f23dd444fbe61bdb0856d4a63ee2d08d07b7508f27c628fa48bc256d2f039f7"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f7eccf9fc38211fa3548b6eb6dbcf35892ad428c1a832b14a59ed4e9dcb638c6"
    sha256 cellar: :any, arm64_sequoia: "2dc6a5f811e38b32626640cda9e15ac0190e8a4dac8694f2506db8527be7f993"
    sha256 cellar: :any, arm64_sonoma:  "59e10f444e5bb374608b5fd2a61a070550ebfa631f5e061179f149a86d1c5ef5"
    sha256 cellar: :any, sonoma:        "818f992dc9723957f25fa27ccac3f2f20634eb1506cfbcb0b7a0bc156ae70e9c"
    sha256 cellar: :any, arm64_linux:   "36bb2cae00a6a36950f7494f3c29bcc67397a39a3df331511aebb092b3e499af"
    sha256 cellar: :any, x86_64_linux:  "3a1b5d72c41d0f22c9b0f563b44e0c3dd726890a392ba3ad64ddbcce05e2c34e"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
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
