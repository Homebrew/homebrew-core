class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/9c/49/e1ffb6965aa5ba315536c2e8fee08195075714a12915f1d5abbf7bf5366c/translate_toolkit-3.19.1.tar.gz"
  sha256 "9dedb0fec957e13e3b3a7e2312c4e848c84ebdae0f0f14f911bd6005f3ea3284"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2ad953b77f4f37e4d2b2ed3f5fc701b643a77c2727239eeafd4c840859c9631"
    sha256 cellar: :any,                 arm64_sequoia: "9c96280f53030a4a726fc2b05eb2fe5321f42380d3254c70fdf0a954899c5839"
    sha256 cellar: :any,                 arm64_sonoma:  "faacb46fca62c2cfaa39f8e031cea4dca3097e6e6528147b7b2d82583330c336"
    sha256 cellar: :any,                 sonoma:        "24478f3af18d470a400c09967fe8d5961504ae5ab60040aef17ea81f15253650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584493d05ded9e44136c2dd63dda6f3c152ae1f99fc50fb0946dc6944e3b6c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d845511b1ccd3f809c961abaaa11c2b64db837793a8f4d65bd95dec9f02db33b"
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
