class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/22/ca/30de687490a993e43734333778a5e6b60994f7a76238910de61a33796c60/translate_toolkit-3.14.6.tar.gz"
  sha256 "d850adf03f86484bf9c5eae203c913ed3d918dbf3a8f008d9b15602a7286e79e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548fd20865101933c3dd9566f95c68e08bb00502800cd312dc04305f5736666d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c07db07d124067e4e0f0e1d426768b490c999edde07a54fd60d1569e5652538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfe55214460fe110c2db604cf175b03fafe6028c546a3d557d025f526b1de143"
    sha256 cellar: :any_skip_relocation, sonoma:        "bae699593a534000476b5d3d33543f0f5b55d730b483efa3106910844fc734b5"
    sha256 cellar: :any_skip_relocation, ventura:       "1afa2b5d1a037ea1d3054064f3fe65e24867cf66ae2bc60622e1757a143011a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91e12eb61cbcdbba4cd5259ee32ae5e751e11c774f9a828b25c1f5c47fede0d4"
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
