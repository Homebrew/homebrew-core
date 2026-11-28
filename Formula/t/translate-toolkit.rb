class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ee/4b/ef63ccdcd80657889b2402aca38e1be854e16c02e847faa0b6c7e9c5d2ef/translate_toolkit-3.21.0.tar.gz"
  sha256 "55c3a87bc59260c2043e6c2e9f1a87a16bfe374a0d6ac7f8bdc6afa8d3d155ba"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    manifest_sha256 "8fd8a524b238a191a08afcee48608f0326db704fc40d8eb26de7c9eefd8f3107"
    sha256 cellar: :any, arm64_golden_gate: "50813a168d055098d5814847dff23385d0dd6188d17682c7ec68cfdbfa1db7bc"
    sha256 cellar: :any, arm64_tahoe:       "7c9590676eb918c7ee16562f133e2407aa6a2e37fe3ff38f6d5a14efe2a24b27"
    sha256 cellar: :any, arm64_sequoia:     "1aaeae72759af0ee2a1e41bb6ead2fe0766e515ce35cbfad4b1de652b743653d"
    sha256 cellar: :any, arm64_linux:       "e0401a287a65430b6c8b06780cd269c32681ab5696a386e57ea24425f820f5af"
    sha256 cellar: :any, x86_64_linux:      "c8f2c9cf14310d182aa71fc5bc65f10145f65d6ad4b42613bd893aaa447c2c60"
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
