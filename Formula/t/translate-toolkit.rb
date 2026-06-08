class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/73/72/5a2de371d9d06817108957b5aa8f3405090c65502b876a9ed70dfe02e63b/translate_toolkit-3.19.11.tar.gz"
  sha256 "e0b6139ce84053a820f3b78782dd889263da97be2715f101fad698b254b54be6"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "011a15ce86def648137628378b2df6aa34c0d12b45e8eb44e7c433fc5fb61ae5"
    sha256 cellar: :any, arm64_sequoia: "4c3eccc39054668c8061f57fe741f992636905127a8914b91d6b43c69a44532a"
    sha256 cellar: :any, arm64_sonoma:  "7ee26c8630a4cd9a69e00aaddde2ef34e6aa3dc30d654a078138375273a37cb8"
    sha256 cellar: :any, sonoma:        "2054760d73464e800d1e36ab51b6def1a27243b6eeaa6c3192a4d177fa837863"
    sha256 cellar: :any, arm64_linux:   "779a29f0fda58128496bb05444c6a87f10aaa8c53f45c1e23501315b664bb298"
    sha256 cellar: :any, x86_64_linux:  "82d5d5d29a8827419bc3473a54dad397018a310f1e251d9b8c40bd88cadf929e"
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
