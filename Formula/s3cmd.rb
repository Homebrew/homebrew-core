class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/c7/eb/5143fe1884af2303cb7b23f453e5c9f337af46c2281581fc40ab5322dee4/s3cmd-2.1.0.tar.gz"
  sha256 "966b0a494a916fc3b4324de38f089c86c70ee90e8e1cae6d59102103a4c0cc03"
  license "GPL-2.0-or-later"
  revision 3
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
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/26/60/6d45e0e7043f5a7bf15238ca451256a78d3c5fe02cd372f0ed6d888a16d5/python-magic-0.4.22.tar.gz"
    sha256 "ca884349f2c92ce830e3f498c5b7c7051fe2942c3ee4332f65213b8ebff15a62"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
