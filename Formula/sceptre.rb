class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://sceptre.cloudreach.com"
  url "https://files.pythonhosted.org/packages/07/de/f3a9def5a49b9085e1b74f807d0087c8fb1c1e40497f692e92ed0d841117/sceptre-2.7.0.tar.gz"
  sha256 "34e3bda077c87d22f6be2731baf18123a6be6d716d49c6b4e4a4024b3c435ee8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129cec4ef2b5feee2f5351ea8e194c0990b5797002e26ac076931a1b8d5bcc61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f4687c01403d63aaad76986c626b7d14cba5a1c4d1182cc2b3b6ac6f63a5b9"
    sha256 cellar: :any_skip_relocation, monterey:       "22b6e4a7d595b1bde5c8bbf6c714a41a16bc2299ad337827fa5c7a6eec3bc66f"
    sha256 cellar: :any_skip_relocation, big_sur:        "30fb1808ef410c3d7d1efe06ef34bcabd3f4b9900af9256af0bdd8f031efd7a3"
    sha256 cellar: :any_skip_relocation, catalina:       "193ea72c2311abe56e3fd7557e18d7b5bcc7da892c5ca347ab4ffc64cbabd7ec"
    sha256 cellar: :any_skip_relocation, mojave:         "73ccdaa2070aeb74acaab1637770cf1c4067508c3ee8b77c78698ceb61115c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0158fccbd85c3050e504c2cd23b5a4e05fa0abc6e385b47620a4b443137d2fb1"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f2/03/837e75a4ac7fd3057861fd4c618053654317da75b2f9f510c47480ef04a3/boto3-1.20.8.tar.gz"
    sha256 "81ebdcabc534a52e2b7a2bfcbe1a1d7f1e34f028f7fe1cb16ccd80e34cea867a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1f/06/613ec6132cafbf85d482bf6377ce3c24cba8b195ed8f0ee4e9be9fec2f6c/botocore-1.23.9.tar.gz"
    sha256 "810e259776bdc233c60333ff9d5f4d14b48ca5adefb9198d5ac8410c1d90efc4"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/75/ee/d6a0129ae8ade3e8082e2b92d9f1e93bf7f727d828243bd4de04c2d9b581/deepdiff-5.6.0.tar.gz"
    sha256 "e3f1c3a375c7ea5ca69dba6f7920f9368658318ff1d8a496293c79481f48e649"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz"
    sha256 "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/f5/ab/8252360bfe965bba31ec05112b3067bd129ce4800d89e0b85613bc6044f6/ordered-set-4.0.2.tar.gz"
    sha256 "ba93b2df055bca202116ec44b9bead3df33ea63a7d5827ff8e16738b97f33a95"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "sceptre-cmd-resolver" do
    url "https://files.pythonhosted.org/packages/73/0f/856f981a801ebce3c1e27fede161ade6f0beaf6ae2584506e4b51f3818a2/sceptre-cmd-resolver-1.2.0.tar.gz"
    sha256 "b748f5023a4f84be6e34439dea4be53f641e3b474640ab9584f0eeb07ebc2f1c"
  end

  resource "sceptre-file-resolver" do
    url "https://files.pythonhosted.org/packages/ee/1b/cf6d885820f1cdbb93de98fd2aebcd903eaf1c5c7240b84fe831e29b6380/sceptre-file-resolver-1.0.4.tar.gz"
    sha256 "8c148653e723fb71d7a442ee2ff9ecb499f44b17fd1d7f7af3a2130f56b399f5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sceptre", "--help"
  end
end
