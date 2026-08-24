class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/bc/1b/2824215bc282e52bd6ee4b699e931fa7d64ea30fd8831529fdd0920f5969/translate_toolkit-3.19.18.tar.gz"
  sha256 "ef1496e9e0d6d5f9647cd7365f91be161c3197104704e81f3a0017ccc7f4f5b9"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44ab7dbee6b16f4289aadc8e41b2e8d66aed0d65fe2dd3ea70ea7258651d68e1"
    sha256 cellar: :any, arm64_sequoia: "cfc3568d9e7bf3283c2eee7c8f1046e720cbc196979595e15230f99580227e3d"
    sha256 cellar: :any, arm64_sonoma:  "ff15ea09987393f16a57976f43e6b0412c6766705d73036a2904ff3ad5a596c1"
    sha256 cellar: :any, sonoma:        "daf089fa3f040387b7ac1c7d9a737a3a8a41e162c23155d5ed9b04be333640ce"
    sha256 cellar: :any, arm64_linux:   "03075cefffcb8f1cf6d54cbdeceaf1edc985e1bf584c96ac14e4824c7645221b"
    sha256 cellar: :any, x86_64_linux:  "38f946ad4f28d17df05f4ca98a58a39f3dfc6e659b2fc9ac4131daa01d5d4a62"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
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
