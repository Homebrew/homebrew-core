class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/c7/eb/5143fe1884af2303cb7b23f453e5c9f337af46c2281581fc40ab5322dee4/s3cmd-2.1.0.tar.gz"
  sha256 "966b0a494a916fc3b4324de38f089c86c70ee90e8e1cae6d59102103a4c0cc03"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/s3tools/s3cmd.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e664b592e99416b945694ac030208b0ff12c41d9cfd7905dea7f9a5bc46d577d" => :big_sur
    sha256 "e2625bb936c5d4b7965544f722e94acef3565a4844735eedd036b70b3d11ad80" => :arm64_big_sur
    sha256 "140b574c93db1f67b40b7cf22e8468bbcb066ecbbfffb8cf649b31d268a82775" => :catalina
    sha256 "c76760a661e4c9438bd2d0b7016430a99a934ac8e6705727b55bc868a466031d" => :mojave
    sha256 "6c2188352b0662521ee7dac484183e0e0a65a1f802e282dad4d5287fa3c955e6" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
