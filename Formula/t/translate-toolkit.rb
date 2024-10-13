class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e0/62/e87ea8be9fb831ee79b4b75e50d1eeb5959fe094b2cbe80e80c59d477fda/translate_toolkit-3.13.5.tar.gz"
  sha256 "53c59c919e52a9787c0d1d7ccd34df9508e9f58bb84d1d52d27a9bda5203d768"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8158f6b9e79369a0ff2646bda4268951ad8ee0decd19fc2ed1c324ff29e52ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d723837180133bcb6edd6ded55ca241e5c4e31eebb5c1917b85349f2b162d364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d7b4a7cf9797110dc8a89949a8f9ea2049b43f92cdd8baf8a7c75ca11224cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3936de57f092ac713c95a81d1e78e1d130f610edc938994dc835fe5e4a63b6c"
    sha256 cellar: :any_skip_relocation, ventura:       "64685641fb49c325f35c9f52bceadb0d839d8d75a7b2aead46615a30b6ba27ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07767c77f113f9da262cfab5c43b64f045935720cb78781f650f42ccd43fdc98"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
