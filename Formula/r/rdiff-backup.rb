class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a3e78508afa86281241a6ef7071837543e9f4ea84003b997aacfac3371efc37"
    sha256 cellar: :any,                 arm64_ventura:  "175c28ada56c7248912bcfe94af746f4961431188b7dfebc104b83da48099513"
    sha256 cellar: :any,                 arm64_monterey: "a769a38c3536633c0476ebb300658f0d480cd43aea3b4d27ec0f65c8a9d23be8"
    sha256 cellar: :any,                 sonoma:         "ad0a5f045bd9216d039a0c908556a8a6fdd4df3365b1a7de020e22e86a89f271"
    sha256 cellar: :any,                 ventura:        "fde749d182eed068dd48d955f9e7d135066d082b2ba669c1e4504d975917be0f"
    sha256 cellar: :any,                 monterey:       "b74a24cc7a9504ce1c46326a5851ae6836342bf6563becabb13cf64cf9360dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f310b6fa334659767acb53075486db2ecb75ad84f0f134b296c6b6af30ee46"
  end

  depends_on "python-setuptools" => :build
  depends_on "librsync"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
