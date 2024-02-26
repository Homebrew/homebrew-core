class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/b3/9c/ad4cd51328bd7a058bfda6739bc061c63ee3531ad2fbc6e672518a1eed01/s3cmd-2.4.0.tar.gz"
  sha256 "6b567521be1c151323f2059c8feec85ded96b6f184ff80535837fea33798b40b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb8d82a6476daf7e1069516fc934dfdafde4efb90c5b8dc6cc611d312d2910d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b5e0b92c1081b0b87818b8a6550c7bfba1352af37b8472e71f22912c9c1116a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098c363759f09a7beb68b69601b83fd94d4a41cdc5a2dac1d591ebf635d0c03d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6feed405fafd7adc8d59b976fd079d06b00cf8d4d5cbfe1f662ca2268f84a358"
    sha256 cellar: :any_skip_relocation, ventura:        "fdfd52a2bccbe6d41e7b5d81deb24a0b64d34030f374db37a3ca3a1c47e0a03c"
    sha256 cellar: :any_skip_relocation, monterey:       "10fc03d1017f9455592e87d770033594252b0bec8b07c881d9f55e3979ef6a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61705a20689c0d6ba5480e0fc15970a4951fbdb74e1cb124a81ca047d641fc0"
  end

  depends_on "python@3.12"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
