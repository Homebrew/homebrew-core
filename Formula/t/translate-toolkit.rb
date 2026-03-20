class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b8/24/4cd479256f51dbf8728e3b0be10bce209f8a35809e4fcfa29b72841962b8/translate_toolkit-3.19.3.tar.gz"
  sha256 "a12120f7567e338ac9f3cebc8506e142c9783e182628ebd08303903e1ad54da6"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8879871aba56b078b10ea24d59c00d26a28261f2c659b6bc184f13515734374f"
    sha256 cellar: :any,                 arm64_sequoia: "883874ae4c6e81e2678b72b070d699544534acd6ff85ea919414db2c004b190b"
    sha256 cellar: :any,                 arm64_sonoma:  "d620f62cee760544306cbc410e36ec2713f9b756594c2572f31378481b8c156c"
    sha256 cellar: :any,                 sonoma:        "22896ce5061695c01eb88776077830f69f00b39004f1d6170f75f86e19d52403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9897bdef73780e4e4fcac8edcf5f82bed5f26ea7f317d13bb628f89a10d603ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b944aa227f447efceb0de9279e84a9834021a66f35277f6d342aff8d2d839fff"
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
