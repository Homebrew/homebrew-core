class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/65/6c/f51ba2fbc74916f4fe3883228450306135e13be6dcca03a08d3e91239992/s3cmd-2.2.0.tar.gz"
  sha256 "2a7d2afe09ce5aa9f2ce925b68c6e0c1903dd8d4e4a591cd7047da8e983a99c3"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4629ce0910520b758907fb6e34ba11d541682518dcfdbc170f99892b86bfcd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b8cacde3f02b35d2b7fbc0996fa66c6423b566a7d1165a630c7b3826518c4cf"
    sha256 cellar: :any_skip_relocation, catalina:      "5f553edd6ee20fe32966ef171dc21ac741c3ed466e9d4df1c6f787f161d0b71d"
    sha256 cellar: :any_skip_relocation, mojave:        "f1ef823594cb909fb04b0902b8d02bd1f372ea2f13d0094207e8139b0f2f439a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ae3afd06194131ef14b5d4ce0c2f7234dcbb0214454cbf47f0923a6c04f563"
  end

  # s3cmd version 2.1.0 is not compatible with Python 3.9, know issues are:
  # - https://github.com/s3tools/s3cmd/issues/1146
  # - https://github.com/s3tools/s3cmd/pull/1144
  # - https://github.com/s3tools/s3cmd/pull/1137
  # Do not bump Python version until these issues are fixed, probably when version 2.2.0 is released.
  depends_on "python@3.8"
  depends_on "six"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
