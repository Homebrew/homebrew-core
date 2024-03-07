class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://files.pythonhosted.org/packages/1e/ed/e25e1f4fffbdfd0446f1c45504759e54676da0cde5a844d201181583fce4/ydiff-1.2.tar.gz"
  sha256 "f5430577ecd30974d766ee9b8333e06dc76a947b4aae36d39612a0787865a121"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19ee8a1c937369430282cbd2f7cf269b9d96f09abf2f1ea8d89347a829ea047e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf4bdaea2c095aeeb6898af0427d933e7ef75d7bdf24e2c4e816c7db6f9dffd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebacd80de18c253475b438d029e8e38f0ff14a598dba7129d0685e727b4ea26f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdb09bbe71fe3a2a31a39a360b189ab3ec91d88b38f34421e09ad7a97b9c7768"
    sha256 cellar: :any_skip_relocation, ventura:        "aa35b53ae4de532ac6aac3eeeb9f5cc5147fe2747295f1af2910c4cb72432220"
    sha256 cellar: :any_skip_relocation, monterey:       "eb9f8a23eb756125eb81cf3c7340c2760ef13ad6581b6745e07ef09ab7fdd74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a516a84269d8f058ff8d271fce358dac1b58da7b49f2942854b829944890c29"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
