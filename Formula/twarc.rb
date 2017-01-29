class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.0.5.tar.gz"
  sha256 "d980c57bcb9030205dfa233379431f20c6d7e4ce6badc3026b68bcde050084f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1613c5a676bdbfc2f9d46c03674ee42e6cfde8b31ad040c64c2d51e232034473" => :sierra
    sha256 "efd78b2c07fecee0bb978e280e297c7c7f3425af25ef2273d955e258d57e528a" => :el_capitan
    sha256 "393fe1429e6a8ee310ea84f6c63bfb0906758f4e4c74c9853024c7a0b4942170" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/d2/4c/5ac894a469e25ebd02f6b3c2adb9f55253e6d1ca1f16a7d247ae6d48b4c8/oauthlib-2.0.1.tar.gz"
    sha256 "132ad46df25e53a84b33f1fd43f80e973cda2cb018cc0168d7d0c8c4d5cef9b5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/f4/9a/8dfda23f36600dd701c6722316ba8a3ab4b990261f83e7d3ffc6dfedf7ef/py-1.4.31.tar.gz"
    sha256 "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/2f/03/0c636d7191255e1737012e5f9c42368f11b55463aeea46fb1955892cab0d/pytest-3.0.4.tar.gz"
    sha256 "879fee2c1fdbaacd1bf2c0047677c6dd4aee05b9c1e64330b34d130a584fa40d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/46/9b/c28061cc63298bc29ff7d668e18c5293bb522e946aaeb98e4c552d2c0f7b/requests-oauthlib-0.7.0.tar.gz"
    sha256 "198807c592b75438485c890f0403b1a8e363c86be1a87da687be18991a6850b0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
