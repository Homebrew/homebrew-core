class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/8c/0b/44ee3656e5382462d8ca0fdbaa09df1c3e7b5414e3ae778984d6b2ecaff5/translate_toolkit-3.20.0.tar.gz"
  sha256 "0cfa591c205331ce2238ea2a8fc4c3204bf399af05ad90da6ed3e3058ed315ec"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3587239357879783bf164e6634ea625939226c1784b305023b53b570418b94f4"
    sha256 cellar: :any, arm64_tahoe:       "fb076a029616a054e673a8e83c758361a10016a279a056239499e1d48966f728"
    sha256 cellar: :any, arm64_sequoia:     "2b0f0b133db901b4e7f979d84c7b031893ca6522bb055e06921ca5e415da6fec"
    sha256 cellar: :any, arm64_linux:       "2b0dbddeeeb77b641e062ae9de0d7f1ba628b4b314671d9e2afeb7b764961be9"
    sha256 cellar: :any, x86_64_linux:      "604d3c14d0560c0bd75b5e7d0e73301371dbf26d8cd630ff003438983f3a479c"
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
