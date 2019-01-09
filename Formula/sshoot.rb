class Sshoot < Formula
  include Language::Python::Virtualenv

  desc "Manage sshuttle VPN sessions"
  homepage "https://github.com/albertodonato/sshoot"
  url "https://github.com/albertodonato/sshoot.git",
      :tag      => "v1.4.1"
  revision 1
  head "https://github.com/albertodonato/sshoot.git"

  depends_on "python"
  depends_on "sshuttle"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/9c/9a/8fac79730415c87b806d768812e6bba04f199cdd2f8562ebd67fba58922b/prettytable-0.7.tar.gz"
    sha256 "7b5df88a819145657ae64cab4bc32dd19dce16ed1263584b08f4c5199443b80d"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/21/9741e5e5e63245a8cdafb32ffc738bff6e7ef6253b65953e77933e56ce88/argcomplete-1.9.4.tar.gz"
    sha256 "06c8a54ffaa6bfc9006314498742ec8843601206a3b94212f82657673662ecf1"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshoot", "-V"
  end
end
