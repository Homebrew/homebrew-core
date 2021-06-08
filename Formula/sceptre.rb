class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://sceptre.cloudreach.com"
  url "https://files.pythonhosted.org/packages/54/0d/f48f7a7c1e5a49ead5e531e3087674bcbec050bce262bb4486e7c03d3a33/sceptre-2.5.0.tar.gz"
  sha256 "40f4ceae1a4d66cbea94cbff04411e20f14c85be2547197de744f1fb09e986d9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26f8ed58058ca751e85b3b05c06ed3641ce3990808f65f1b390bcc5476177a04"
    sha256 cellar: :any_skip_relocation, big_sur:       "514534fe3b3bc01e2db9858b1d9a58b15e3e0a87fd86c109d0420897a6d81095"
    sha256 cellar: :any_skip_relocation, catalina:      "fd468b6d8cb0ff2583e2a396fd5fe49cde82cb5c16f1dcb34ed452646716139b"
    sha256 cellar: :any_skip_relocation, mojave:        "a48375a0271b441d4d3df4dc2ff430b27aba357e58df5dae6ee3e5cf38ea1d82"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/40/5b/a25eb36bd333f246ab47705bf4ce3a3512c62612470cc8956e0b214deca7/boto3-1.17.67.tar.gz"
    sha256 "61fe8cbb2d4bf1c9a69a73b3f2c68464e0ab587c9367b35f0ef691f372d5ce67"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/af/70/4fb7c31c7dc3a43aa716a3b1dca4f0b37c71998af7c74c40dba844c919bc/botocore-1.20.67.tar.gz"
    sha256 "4666fb5bdf7d78c51d465bac7d9eb1d31c34be46990cd1ad2d1b338bbec8c049"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
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
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
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
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sceptre", "--help"
  end
end
