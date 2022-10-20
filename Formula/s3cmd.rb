class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb414acde1db4bb6928bcd7d324ece8d76789d2317dcc1e7bba62d68b3c5ca1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d0c5b731e391732e95079cb1f9d77a06f573c0d8399ea75c130796decfb6d35"
    sha256 cellar: :any_skip_relocation, monterey:       "b5bce6966cadc7ded6bc9665dd46cb0139fbbe0a77c015ee0815700ea057eb18"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4b3ff0cd6989280a0aa7bfb6e530d9e4eb1ce4f2b0dea621ba168a6a10c0b55"
    sha256 cellar: :any_skip_relocation, catalina:       "c15344cf5ced2e4c47e552d06c48e43320e7c52289d7d8dd4b10cd63a3c222e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9a466725bc9a3478b70e2b9708fedf6d83fb32b5f9562ad74f90fe5c6a2c64"
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
