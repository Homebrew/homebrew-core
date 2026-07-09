class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/a6/90/8d60a44eae3715809a93017efc71387b675efad61365b3a557808ded8235/translate_toolkit-3.19.13.tar.gz"
  sha256 "56e57673c6a17d6cd75176fc31b207b1baf1a5008e09e17c810d940dbe6b41ed"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cda93dd145d1603ccd36415694b1efe0e0717b9a481059d7f301adb9f0605d7f"
    sha256 cellar: :any, arm64_sequoia: "353f15b488577f333e7edc06e1b5983ed874aadc221c87b1219f2dca6ccc6016"
    sha256 cellar: :any, arm64_sonoma:  "4fc704cd53c74da93e474530bce67a096812685036fb22868fbe7ad139733fd0"
    sha256 cellar: :any, sonoma:        "9b09324f926360abf4ba208953bb73461cb1ca2cd6990e1695d9695d9481bf2e"
    sha256 cellar: :any, arm64_linux:   "33d95380fb0f2d862b4d34a690adb2128ce20ad8b550ca4d65b727129242c199"
    sha256 cellar: :any, x86_64_linux:  "3890b816100f3f79db3ec7052929a05317ef192aa113bd2c661008353ee76ef0"
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
