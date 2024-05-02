class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "ff8a427c988c6d1e3217145fe0f523317ca9f0923b285f81548fc7454208b432"
    sha256 cellar: :any,                 arm64_ventura:  "da3a41317c08c7843b6fbbb8fc3e0e6af467b2ff3a60a6a92ce8aff0aa7fc41c"
    sha256 cellar: :any,                 arm64_monterey: "74396cb4ee9b8c8c6fa1096a818a3bd54ecc2795865e865e02c6fa70a4885509"
    sha256 cellar: :any,                 sonoma:         "a2993b72aee045eaea3b6965bb2ac4bc986304c25f36732abdcfce7a464a2c9c"
    sha256 cellar: :any,                 ventura:        "b78453d46cce36258eb13fa06022faa32e7f65448bc1115e9a9342f8d7df6ab2"
    sha256 cellar: :any,                 monterey:       "03241fa97fd63a5a44283d285342e7a650136d0eab6a5d95cea9f5575b8d9f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811ca55b1517942476402713af81af0d01d2fce1927a899dda18af755f08a33a"
  end

  depends_on "librsync"
  depends_on "libyaml"
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
