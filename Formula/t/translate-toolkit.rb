class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/30/32/d5ec62e080b454554c06a3557aa0969e0036c28149da8a7ac53b7ee65800/translate_toolkit-3.14.1.tar.gz"
  sha256 "2148c437c529d4eaf89c5a3bd5690376eabee97c3c39b7d4824001a7cf333e86"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae6d2cc2e897a02a78f54f79edd72e731f9c3749fb3f52106e6ac0f5e1b82c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c2a0cabbdbfbe74b43250fda9bb2092bdc1a309fd703c7daacc7560f90b376f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "867308913f6ccaf8f996da7f8867caeb766da397680b7f77b1877603ae16f76b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0235351a0dfcacc2922c175d87d4d48d4efdc29cea0124632a14abb9abf5c26"
    sha256 cellar: :any_skip_relocation, ventura:       "bcbd271c0b75bd0b16a06cac62ecd1de23eb26ec3a6729742a1cba57daa8cfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d80ff8da916c4c7a4255109bb18d23f313badb512b86bffa9fee7f51b566bce"
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
