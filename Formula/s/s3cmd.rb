class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/b3/9c/ad4cd51328bd7a058bfda6739bc061c63ee3531ad2fbc6e672518a1eed01/s3cmd-2.4.0.tar.gz"
  sha256 "6b567521be1c151323f2059c8feec85ded96b6f184ff80535837fea33798b40b"
  license "GPL-2.0-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1631a1bb7891333d5ecce1b16c49e861aea505efcbb21d660408819593565ae8"
  end

  depends_on "libmagic" => :no_linkage # for python-magic
  depends_on "python@3.15"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    venv = virtualenv_install_with_resources

    # Build an `:all` bottle
    inreplace venv.site_packages/"magic/loader.py", "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    (testpath/".s3cfg").write <<~INI
      [default]
      access_key = FAKE_KEY
      secret_key = FAKE_SECRET
    INI
    output = shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 77)
    assert_match "ERROR: S3 error: 403 (InvalidAccessKeyId)", output

    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
