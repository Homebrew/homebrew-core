class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49c063c7d2a9ebf7ac266f11525017060f22663920a73720956c849ff6dc5dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bba070e3a04a80a8004e89aa7e97d765ddd226105bd8f9bb05bb9f440f2d1d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85c3ca73d459db2aefe03eb0eb2f18ddf2910288fe50517ec41802cd6b6964d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e127cee8042729628fdfd70c6e122182e1a855ee7a2173be63629ca17b5a5e38"
    sha256 cellar: :any_skip_relocation, ventura:        "44621e3c588d8d9933fc542f5fee916ca68930fa9c4d5406555fae6c01461c11"
    sha256 cellar: :any_skip_relocation, monterey:       "d8fb2514382324799db5a36644469aa64905008a72713774493e814da5706ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9785c7ced06c286975b392882d054a445556ce494d3f0f6c68838b7ac937fdfc"
  end

  depends_on "python@3.12"
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
