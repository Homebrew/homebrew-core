class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d3197b26ede962687b3f7e44063b70c51b58eafa800578f01c0a716770833ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8ebf2e5482148ab05fb5566a0daf181701b4a8019bd1fba40d1a8854a926c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62239bfac256904c14d9aa9deccdc54d27f8b97dcf47fbb593386c07ec362c5c"
    sha256 cellar: :any_skip_relocation, ventura:        "98a569dab7f76373fc587e335f8d705fd46b0a60f773dc8e35477cdae7cae35a"
    sha256 cellar: :any_skip_relocation, monterey:       "42221c8da5a493e2fdb7e1752603f2de8fd7308f2d8790c7bbdf5bd1b96efef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6157f2ba122b52f4f8d4f312bf981f621afb4339266c086e24ced420bf43f2"
    sha256 cellar: :any_skip_relocation, catalina:       "2168e52f58b88cded9291ff6fce6ae6fe5c271d9e4f19aa4b35fc286b7281b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ff4870317c568b8cdef59aa0c83c587ecd0539a9d231597ace36a25f78a6f0"
  end

  depends_on "python@3.11"
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
