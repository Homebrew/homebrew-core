class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/f8/9a/060d7b777e3c76ffb0e5c41f7040ae597e3f9ddec739be61c35d095d9699/translate_toolkit-3.20.3.tar.gz"
  sha256 "b14b1c92418ec2945296eb19d711f228519ed606e63f4a8801f6bcdfe4f5a6b2"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59d72485d97495d5d88f036dc48d8b9264f495b29b4714d716cb6bfb187679a1"
    sha256 cellar: :any, arm64_tahoe:       "f046c91114b7f5d74fbe444e00eed4e134ff2c259afa60fd1712ea16ae2742a5"
    sha256 cellar: :any, arm64_sequoia:     "0c79ddd6eaf8e16054b8b93b53f0b201fa324e6981174205d31b904f03709811"
    sha256 cellar: :any, arm64_linux:       "da453ba6f7aeb9f8397a0e29ad4b9c8c1eb20f41ec494fe140ae6d4f760a8f5b"
    sha256 cellar: :any, x86_64_linux:      "d2a4c397d9f734e90a1fb5c81f457f9bb8a6e3528ecb9bd246f1293e4fb59e0d"
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
