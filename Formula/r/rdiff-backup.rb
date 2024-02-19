class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "62a12dbf5e750987a1a6afbe81cb89366e4c591b0a99a42b2473610ac366ec8a"
    sha256 cellar: :any,                 arm64_ventura:  "f31e3f9d90f28f2e8600c5dd1956b0a9df5902268b53c152fa5b721d52c0bb77"
    sha256 cellar: :any,                 arm64_monterey: "893f90f342759922aeebccc17bdc7683377a967406f12eaa8ab44dfaa3ae7b49"
    sha256 cellar: :any,                 sonoma:         "c984ff93acdcb76f458954594e064dab73dc370941f2f5f019c9237e8198c99e"
    sha256 cellar: :any,                 ventura:        "f172827a94012d6e471df1e73d7774593949d1d725a9715dd344a1e1ab043441"
    sha256 cellar: :any,                 monterey:       "9a54b66ed56540b4f2b460fe4226fc8229403cfef70884e2f31d60abcdf7f2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad5d8f59011596de1dbc0325a153d7deb17ab2d1336c32a4fa53859ad0055dd"
  end

  depends_on "librsync"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
