class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b037ef3ea3aafd39f744cea23f2523f40d9c80661a074f50069884c55eaade80"
    sha256 cellar: :any,                 arm64_sonoma:  "b0cf4abfe62e3c09b9345ec38d5c7f65c9837242678e0e7dc320923ed717ecd1"
    sha256 cellar: :any,                 arm64_ventura: "20fa233aaa55c026ad35248b7a3a2071b8033e6d5ddecce0e63d0fbe91d87e00"
    sha256 cellar: :any,                 sonoma:        "5691e0d4ef52851e4fa7c4cb79f88d67d36452dd47d5a1ed431c4ea3af28bedf"
    sha256 cellar: :any,                 ventura:       "695783fe127849af52c616ca92258b2a68a9c9b44d8e0a16b01018188ed09422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5337ec00dc8e1870c11e94a94aa00868fc261fe1450d269ed856e7fe610d31c"
  end

  depends_on "librsync"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"rdiff-backup", "--version"
  end
end
