class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v0.8.2.tar.gz"
  sha256 "6d5151c722dc3da53151456c012b69cb0cc627667cb01323857064d5ce5ebd0f"

  bottle do
    sha256 "6e8946c79c64788c5b06b054a9e118c355fdacba3999b433706f85dd134dabca" => :sierra
    sha256 "fdcc08b9d1557e4fe47d004f88d49aeaff4cc57aa2fd7976452697085026f024" => :el_capitan
    sha256 "4a714b96010c09fd184dfcc6f56e464be879cc7c95ea9c0461a5fc31f3db196a" => :yosemite
  end

  depends_on :python

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ce/92/7f07412a4f04e55c1e83a09c6fd48075b5df96c1dbd4078c3407c5be1dff/oauthlib-2.0.0.tar.gz"
    sha256 "0ad22b4f03fd75ef18d5793e1fed5e2361af5d374009f7722b4af390a0030dfd"
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
    url "https://files.pythonhosted.org/packages/a0/2f/076c816e2402c4911ccee4b93ba0475145b7cffd0320ca8efa0add7c469c/pytest-3.0.3.tar.gz"
    sha256 "f213500a356800a483e8a146ff971ae14a8df3f2c0ae4145181aad96996abee7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
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
    assert_equal "twarc #{version}", shell_output("#{bin}/twarc.py -v 2>&1").chomp
  end
end
