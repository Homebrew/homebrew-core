class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e3/2c/0caf82e1bc8903c00dc7f6b8f2249efc8a1463c61f9277d6a427184aebdf/translate_toolkit-3.19.8.tar.gz"
  sha256 "161f19f7c156e7f337f63be22ddaa17c4f2e373b50d50bd1860abeb6b033a863"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71eb1d015e38690f014227abbd30565255af5e1e2ccc65cd1f67d2203bb2af2a"
    sha256 cellar: :any,                 arm64_sequoia: "a1adae886ec062f2b26ab1e1fceacf80bc570361a741f4fedd09d174d25d1015"
    sha256 cellar: :any,                 arm64_sonoma:  "07e3ee98281494df3e1bcd1e5902b1374913baf2c1fb54765a67ccb6a0713b6d"
    sha256 cellar: :any,                 sonoma:        "968a7a2f5627b855549fe62b7fc29176059282337c8db6343a831f9b6b806194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17aaa227b1c2bb3e2cf310d32a658baa1381384daa6467ceff10fe8d96c6716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398adce8ccd012c6c9dd79bea3d008d9fff530068fb0b52cefa8d227bb47e402"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
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
