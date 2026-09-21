class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/8c/0b/44ee3656e5382462d8ca0fdbaa09df1c3e7b5414e3ae778984d6b2ecaff5/translate_toolkit-3.20.0.tar.gz"
  sha256 "0cfa591c205331ce2238ea2a8fc4c3204bf399af05ad90da6ed3e3058ed315ec"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fda8ec4ccda2f91401d25c781bea3e4fa92496e159c77867253e5680a399ad39"
    sha256 cellar: :any, arm64_tahoe:       "dd1c7eafd1a294d4e8f79a789837bfee700fa0a4331f5a2d516fd7083b6e77c9"
    sha256 cellar: :any, arm64_sequoia:     "fb36d5f441993023ed146234f556d9c3a31510d6dfbc3cb242447239736a5ddf"
    sha256 cellar: :any, arm64_linux:       "7e47bbb5adbb8b896ade22eb496b0a46d42bab3896800a931158698f4d3f823b"
    sha256 cellar: :any, x86_64_linux:      "80e7b54def0f7bc92bbb5c25019c7e93043a08a47867245d5ffbcf2da16b7da4"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/0b/02/e5804acc54945ecf29a280f5f173db61c019166bfe3adeee386f4c135f17/unicode_segmentation_rs-0.3.3.tar.gz"
    sha256 "d6625b2d3435ca814c9dd6590d39ae58ebeb8a4891eecb81446ad8b3e917f39b"
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
