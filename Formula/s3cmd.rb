class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13cdf4fa4a22bff28b1c6d45e9b6abf3dc32706b5480aecfb795cd78bbb6a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28e7375d0037bcfc45a8e78bd25cea0607b2b84889a36c33b01928d665594c9e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f1bb8a93419af123b4ef632fedee428b53803e768f90e1baf1fc9001d87b688"
    sha256 cellar: :any_skip_relocation, big_sur:        "902b90e870a713c0317c2c7b9473b864e0e71c55dca645ea05ec6e928f4ab1d3"
    sha256 cellar: :any_skip_relocation, catalina:       "8f4c613de5672026788b198f0599a1b8f411c052485c9bee0d0afdba8c31ec62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033fd52dfc82b54e62c50d07244b35d53b1b60f1b4bb6d6e66e17ce121b8ec8d"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
