class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/c7/eb/5143fe1884af2303cb7b23f453e5c9f337af46c2281581fc40ab5322dee4/s3cmd-2.1.0.tar.gz"
  sha256 "966b0a494a916fc3b4324de38f089c86c70ee90e8e1cae6d59102103a4c0cc03"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2625bb936c5d4b7965544f722e94acef3565a4844735eedd036b70b3d11ad80"
    sha256 cellar: :any_skip_relocation, big_sur:       "e664b592e99416b945694ac030208b0ff12c41d9cfd7905dea7f9a5bc46d577d"
    sha256 cellar: :any_skip_relocation, catalina:      "140b574c93db1f67b40b7cf22e8468bbcb066ecbbfffb8cf649b31d268a82775"
    sha256 cellar: :any_skip_relocation, mojave:        "c76760a661e4c9438bd2d0b7016430a99a934ac8e6705727b55bc868a466031d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "6c2188352b0662521ee7dac484183e0e0a65a1f802e282dad4d5287fa3c955e6"
  end

  # s3cmd version 2.1.0 is not compatible with Python 3.9, know issues are:
  # - https://github.com/s3tools/s3cmd/issues/1146
  # - https://github.com/s3tools/s3cmd/pull/1144
  # - https://github.com/s3tools/s3cmd/pull/1137
  # Do not bump Python version until these issues are fixed, probably when version 2.2.0 is released.
  depends_on "python@3.8"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/26/60/6d45e0e7043f5a7bf15238ca451256a78d3c5fe02cd372f0ed6d888a16d5/python-magic-0.4.22.tar.gz"
    sha256 "ca884349f2c92ce830e3f498c5b7c7051fe2942c3ee4332f65213b8ebff15a62"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
