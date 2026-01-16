class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/04/f7/22a5651992c4e9bc22820d5677f9bee8d20b1a23140b9a388c424f80247e/translate_toolkit-3.18.1.tar.gz"
  sha256 "24d59108acdedf2f923876fa825b0f9c08bfc1998038d545d11fb63470094acc"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b4fced6fbac18650fd9399b9755eb3fbce01434555dc16fdb5fd81296f99c82"
    sha256 cellar: :any,                 arm64_sequoia: "e0d2618ec95abc0d5114c9a2635d6ca1badf3e9129e9037d6c8616b6e1097a9e"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bf831f873d5b1ec16ff6059f8a91bd181a59e812d8f92d41bfe188b4de84b9"
    sha256 cellar: :any,                 sonoma:        "1df900e17ace4d2768d8af62cf4be79687f1784916a6660825d4b3b5423ba0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bab291b9b8c972a755d8416831a5f8e21c54bb545161337f992743176c4c9a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10aa9ebece1b66a3c50837689c7cf5b9121c54af3508ac2bc5e451b30582ec80"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/a3/64/009d1e74801a5a38158c11bdb350e7417eb01ed9b1eb45f236154cfa77ce/unicode_segmentation_rs-0.2.1.tar.gz"
    sha256 "ca01aa024a6580960bdab8e4a1a0f1287e9592e66dfdae9e51a1d05f43768e78"
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
