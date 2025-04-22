class RichCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line toolbox for fancy output in the terminal"
  homepage "https://github.com/textualize/rich-cli"
  url "https://files.pythonhosted.org/packages/ca/55/e35962573948a148a4f63416d95d25fe75feb06d9ae2f9bb35adc416f894/rich-cli-1.8.0.tar.gz"
  sha256 "7f99ed213fb18c25999b644335f74d2be621a3a68593359e7fc62e95fe7e9a8a"
  license "MIT"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c3304709ad3006fba00a93e4be5df3a01915f2e1ce0139f10a75f2b1c948e176"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/b0/69/5514c3a87b5f10f09a34bb011bc0927bc12c596c8dae5915604e71abc386/rich_rst-1.3.1.tar.gz"
    sha256 "fad46e3ba42785ea8c1785e2ceaa56e0ffa32dbe5410dec432f37e4107c4f383"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/8c/d1/c228993e8a21e24bb43a0376b2901b6f3f2033dae13e7f76d1103bb9b8a3/textual-0.1.18.tar.gz"
    sha256 "b2883f8ed291de58b9aa73de6d24bbaae0174687487458a4eb2a7c188a2acf23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"rich", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/rich foo.md").strip
  end
end
