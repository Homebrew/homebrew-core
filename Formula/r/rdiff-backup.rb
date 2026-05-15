class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "ebea57ecc6915c0b154d732cc9694f360c77815e98d8b81948e6e52b3bb881b9"
    sha256 cellar: :any,                 arm64_sequoia: "2f5ac3490d900871fae7157a93425498112962b41824c0b725dc3a0acd466673"
    sha256 cellar: :any,                 arm64_sonoma:  "bccc1b81a71c6c37e91412f2083c8922045b07f5a5cf1c11a37924a480f58871"
    sha256 cellar: :any,                 sonoma:        "9136e68895a67828a273cd4930fcbc2dbf8dbf4598c5ba938d4c2825d1f25c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baba91a650c1813d89435bfe1bcc41463e9fa64ff81d79592c70a7219147216b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384758ed7f5ab60a60993d6c73f2a835a878c00cd6066ede4e054334aafc7731"
  end

  depends_on "librsync"
  depends_on "libyaml"
  depends_on "python@3.14"

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
