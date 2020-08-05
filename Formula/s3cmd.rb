class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/c7/eb/5143fe1884af2303cb7b23f453e5c9f337af46c2281581fc40ab5322dee4/s3cmd-2.1.0.tar.gz"
  sha256 "966b0a494a916fc3b4324de38f089c86c70ee90e8e1cae6d59102103a4c0cc03"
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea18ab2445955c20de54537447b5930de60cf8e927fe291f662760d50c0df8db" => :catalina
    sha256 "737880ee8c7e9d73848eec50d87b1b7da7762a8b8d6172fd1f4be173888e18fe" => :mojave
    sha256 "4d2c498462eba573c43413ec16f4681a8e604b67ff6739351900e500e2be5923" => :high_sierra
  end

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
