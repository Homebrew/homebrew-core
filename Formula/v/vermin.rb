class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/3d/26/7b871396c33006c445c25ef7da605ecbd6cef830d577b496d2b73a554f9d/vermin-1.6.0.tar.gz"
  sha256 "6266ca02f55d1c2aa189a610017c132eb2d1934f09e72a955b1eb3820ee6d4ef"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e36fb36651f86fcb5093d034a29a33f8f9e0da02d9b2dd35ad759196494a3c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18474cfbb1b70f5bf4c9e3f1afa8443491042d898f4f9c1b5768fdc49d50ca6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60528b1441c3bd7007cd8dad9d866ba420ec40c769fe32ec5ba31445f781b47f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ff96152823b90961eb3783a77a05f712bdbe25e2c5d1a7d4bb760d2f91fcc93"
    sha256 cellar: :any_skip_relocation, ventura:        "c16871724bbe66b177fb6fe799c524ece91a7faa73433b2469db38ce088d41b2"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f1b627d8a2b7c8bd00bda7e0e78fe90bf87427aa612118fbca642609059d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcfed81bffd33bcf9cb55a7446e5d16c9b3429450a63a0d1a63a9542a6531f32"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/vermin --no-parse-comments #{bin}/vermin")
      Minimum required versions: ~2, ~3
      Note: Not enough evidence to conclude it won't work with Python 2 or 3.
    EOS

    assert_match version.to_s, shell_output("#{bin}/vermin --version")
  end
end
