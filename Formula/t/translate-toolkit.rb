class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e5/42/c747cf80217f1331f924eed11a68cb2c2898ac7135a2edf7962ddcb914eb/translate_toolkit-3.20.4.tar.gz"
  sha256 "e122b31412ab05f9f3c6a29a12eee87440f7483ad99940783cf66cfad5bcb150"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5c1253abde4c61ee34e93e38f0c4eca97cadd6f514bafabf2e09d1f04e07fefb"
    sha256 cellar: :any, arm64_tahoe:       "809ccc0de227f5892830abac798013c9635153f5ed5bd15af6b78e034f9a97d7"
    sha256 cellar: :any, arm64_sequoia:     "d424f2fd226e6b5d6c9f27b949bb05d857c08d190535c1ae224c330d7bcc2ca2"
    sha256 cellar: :any, arm64_linux:       "8e159960e5db0cbba4f056ac445a93462f9e28049317ad1173b69cbadb293b50"
    sha256 cellar: :any, x86_64_linux:      "00cfcc934c3099d55e793241917ba5b5d26a2326456af20a18070dc39c6eda08"
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
