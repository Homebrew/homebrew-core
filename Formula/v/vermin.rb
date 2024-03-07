class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/3d/26/7b871396c33006c445c25ef7da605ecbd6cef830d577b496d2b73a554f9d/vermin-1.6.0.tar.gz"
  sha256 "6266ca02f55d1c2aa189a610017c132eb2d1934f09e72a955b1eb3820ee6d4ef"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95a7e3486feb8990603dfa27834dbe16be6ad931a1546309a5c3dd5f53593803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ae5f182f2388c49e9e69bccfbb0d8a2f4eb41a68ff02c2861b98a3676854c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7109c0f6c180b061158a73e4dc995bd9d4d13659a23058901c2bc0ada77c02e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "61bec38ab180cc2a41f25842117c9120fd6dd9a441c54a23a2485987d397dfd9"
    sha256 cellar: :any_skip_relocation, ventura:        "3428f28c303e7024f6781e1c7b92721d97303a2c42f98d41e301384e7e836cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "6a5b2ff1673cdb57ef1442daf520f8a6f71397574358bc0a1c177e3933f4eec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09aab935f0ca29d76b066a2e4e0b73467b63046f968957389fda7e50bb75256"
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
