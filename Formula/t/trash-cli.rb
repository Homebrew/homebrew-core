class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/96/7c/906fcf701057e67ea9f335d502bfdde2cf353eb149b67fdbc8be4ccd4683/trash_cli-0.26.9.14.tar.gz"
  sha256 "dfff726023223a864181e23ab5e349abb6a8e85d5341c0a4abb1c9340ad8764e"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09318b59716e168dcd6f0b6f4ff6fe54c84f535e5abef40df93fb7a3e472fda0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04b8c55a25837c64348072cb3ce5acb1da34f757c16b3a918544e49401392e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e95d7d7ad03ab0076797af0652366b3995459fb4af9705d67a58354bf6b6a39"
    sha256 cellar: :any,                 arm64_linux:       "27df1b49fa8a2f7d21da52fbc7a1c61edbf7aa0416c141243af42acaea7e7ec5"
    sha256 cellar: :any,                 x86_64_linux:      "2d57ef4af3c555ee6d60b0916140075e8b3814fc40b55a75197be6f9d35e518f"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.14"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end
