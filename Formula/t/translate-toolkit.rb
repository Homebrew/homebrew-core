class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/2b/02/13c1380c8af0c5f5deb54621fbe027434ea1da6675a67462775e93e46476/translate_toolkit-3.16.1.tar.gz"
  sha256 "f8df91586ae9ec7c183a05695d5e84912e3f9be8669d1eabc43fb0536248f8c5"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38fe76407ede997c977a3771fe22b23cedc39d22d624c52a59507829aa564739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd290bb9378f7fd77ff1a3e9633a64025863f52ebf7db5bb641ffb9aa7b9f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2435c21bb84820d2cda2fd3d298cd2f4c7b4557ca82b39c085c6043d2c116079"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "455d4fcd2321b625f46726b01f6f277284c5f97b0797cc9ce2771b782be5f747"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a4a8b2351dcd84fa6fbc8ef6c24e5b4b5e758e33d3b116ed7a6afa2e1e8831"
    sha256 cellar: :any_skip_relocation, ventura:       "597fba962e80c6402140dfbffce98c310139761e00098af97cdb53128d0a1b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927d898603e248a032da3c66b2f952c08fc6ca56a28ede1de9b07a3b7bf0fa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f922270e813f86da6d45444997b8ba4c0801c4e7b5a788efaa35c7bc8b36e7cb"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
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
