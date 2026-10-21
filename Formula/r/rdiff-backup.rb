class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any, arm64_golden_gate: "6ed4437995d6dfb5354c16626742ab2330df442c4722e0f8f5d8293b19f95857"
    sha256 cellar: :any, arm64_tahoe:       "3586159c45c3a4614efd126fc6c4b14070f59d462973db35640a15836bb42e10"
    sha256 cellar: :any, arm64_sequoia:     "fe543f0236e963f360d46bad87fe34a5bcc46ab812c048ef156ccede727ca2ec"
    sha256 cellar: :any, arm64_linux:       "de5aa5852eca3304c45d6a5809d64a118441bb1f3f0dffc8a6bbf186cf924672"
    sha256 cellar: :any, x86_64_linux:      "f6671330b9e3e371e18829c5babec44df0c1147736addec60a39382fd944e3fc"
  end

  depends_on "librsync"
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages extra_packages: "pyxattr"

  resource "pyxattr" do
    url "https://files.pythonhosted.org/packages/97/d1/7b85f2712168dfa26df6471082403013f3f815f3239aee3def17b6fd69ee/pyxattr-0.8.1.tar.gz"
    sha256 "48c578ecf8ea0bd4351b1752470e301a90a3761c7c21f00f953dcf6d6fa6ee5a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"rdiff-backup", "--version"
  end
end
