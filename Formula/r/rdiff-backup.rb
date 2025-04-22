class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "b8a183aadfc497b89651c586a63267398a9ffa1b5fc7181bbb3dba635ed50aa8"
    sha256 cellar: :any,                 arm64_sonoma:  "e23be48d91740ad07bc9a1f6d17a421353fe1c9456c21d14038a7335a516fbdc"
    sha256 cellar: :any,                 arm64_ventura: "eec850cd941f91e122231dbe65f85451f3255baf5237cce8cb6ca6449c0278af"
    sha256 cellar: :any,                 sonoma:        "af6653ad557d8ed7d4a7efefe138381cbd6b470af020456f6aeb0e741ce9c463"
    sha256 cellar: :any,                 ventura:       "3c6b2a8ec13479805311c25991032e477935367a99b87f8f5454ea4c35f6a2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2694d7d63017b164590148e2fd7e2daf87944f017422215dc369d310bf16bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a240b34dd02ee832c2eada0cb754574d303b051e2702b0798bad0ac533db9dd4"
  end

  depends_on "librsync"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyxattr" do
    url "https://files.pythonhosted.org/packages/97/d1/7b85f2712168dfa26df6471082403013f3f815f3239aee3def17b6fd69ee/pyxattr-0.8.1.tar.gz"
    sha256 "48c578ecf8ea0bd4351b1752470e301a90a3761c7c21f00f953dcf6d6fa6ee5a"
  end

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
