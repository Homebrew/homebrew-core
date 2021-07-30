class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://sceptre.cloudreach.com"
  url "https://files.pythonhosted.org/packages/62/d1/5af9618071fb40942a119f42fce35dce3aee49e331aea7025f4a9936b6fb/sceptre-2.6.0.tar.gz"
  sha256 "096eedf1888420d14d0f515a5dabdafdc3b1d18735ea73f0ef40f96379fc928f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f29a291f075c15bbaba3d724d54297fc0e05f5381893392fba9d1c905758d0d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1fab4d3b3a1cb26b74c789c3d455293475737524fa466d6c8b87cd329f64764"
    sha256 cellar: :any_skip_relocation, catalina:      "b67b5d8825e9b965a387142edd92b87b4c71f2593b1fa7fce76065bd27aeaffe"
    sha256 cellar: :any_skip_relocation, mojave:        "6682173f333a2737013ad52d426c8519593a71112f8cde087b24a29e6d9ffadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79115df70342d7d581527dbffd6ae01877f4b9130266a9b8bfd170e9a43d662"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/cd/c0/3032abb4554171cd8452fa65bf24764232a941267cfbdece05103444e792/boto3-1.18.10.tar.gz"
    sha256 "831b279c4395d5f3b360b260131e30d418ffe620ed3705a5146a90ffdd5775ab"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/94/17/92922c9fea51d346a74be1ec6ca3da3cfa9f4cd1a4b9678c8740247c7536/botocore-1.21.10.tar.gz"
    sha256 "af5baac459c9fde0eb7dda39808e7dd1e61d758c3c0a734436ec377e0dabe319"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz"
    sha256 "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "sceptre-cmd-resolver" do
    url "https://files.pythonhosted.org/packages/9d/20/df8d749892d622105b502047fa8950d9ad0025b2c5d936db2db2096e5c71/sceptre-cmd-resolver-1.1.3.tar.gz"
    sha256 "4490387b7689f0d29ff58c79ca9232c091ba1885c6089f2300329bca038a08c1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sceptre", "--help"
  end
end
