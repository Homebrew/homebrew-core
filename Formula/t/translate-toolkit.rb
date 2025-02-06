class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e1/22/6dba0314081a226333bb79fe0a1544c672d7c1f53f7bcf99ecc691e93254/translate_toolkit-3.14.7.tar.gz"
  sha256 "e71a6f37111006e32080709bd913c243f9505a8a7a1e27a9f01a5149ecb7d51d"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cf0c5539df791606f941ef118dac55b04953781690815752c324ef9f6035f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0929335da1c4146c7beec962bca016b93c8dc299fedd242b2f0b1db26cf38b94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a25b27dc218f824c616fcedc09b9055c7cb5d42b322dd734ab08f855f290039e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1acf577821de796bef04d1e30a0304b35fd9b594dea60db509255b535330e400"
    sha256 cellar: :any_skip_relocation, ventura:       "832dcfa99f899abe7e263676b95c63efcb53440f6458940e38d95382a098b115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "983d1a1389fb9d96654afd94b2cd59087bd28cd469aaeeaf31b94177f2e45aef"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/95/e3/275e359662052888bbb262b947d3f157aaf685aaeef4efc8393e4f36d8aa/cwcwidth-0.1.9.tar.gz"
    sha256 "f19d11a0148d4a8cacd064c96e93bca8ce3415a186ae8204038f45e108db76b8"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
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
