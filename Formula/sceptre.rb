class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://sceptre.cloudreach.com"
  url "https://github.com/cloudreach/sceptre/archive/v1.3.2.tar.gz"
  sha256 "c153e20d037b649c56dff5f44ffff0d34c0bef9b89c9f34f2f88f52b726ff465"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d2c8da3a5c8ce3d7cff0c9149a92893f915268620f3b1bfd04948c8c13697c3" => :high_sierra
    sha256 "aa91e716034284bc2b7a106f8b1116c157a7e64db83bf7acd8e5bdcd947c6ea9" => :sierra
    sha256 "fe478a90952e44e026c318220263f9f70fa5eb6c4110b9e4b3bd8d0b22d75cdb" => :el_capitan
  end

  depends_on "python" => :recommended if MacOS.version <= :snow_leopard

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7b/82/ff2cc1627733040b19369d5d561331b378150e02312f1d1b9424a91ae9d0/boto3-1.4.8.tar.gz"
    sha256 "332c6a17fd695581dd6f9ed825ce13c2d5ee3a6f5e1b079bed0ff7293809faf0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/31/01/8af6e1cf7943b54b7a8bad8e9270561035d00b72b430b2ac7daaff13902f/botocore-1.8.6.tar.gz"
    sha256 "58db28effd55b603cb668065cf868804b7ff5680986b79516b5f48600d39819b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz"
    sha256 "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/b1/a6/24d960ee5f21eb2f9e2e938be44b9929bf9f85a570b9582c50c14e7c7ec7/s3transfer-0.1.12.tar.gz"
    sha256 "10891b246296e0049071d56c32953af05cea614dca425a601e4c0be35990121e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    config = testpath.realpath/"config/foo"
    expected = "The environment '#{config}' does not exist."
    output = shell_output("#{bin}/sceptre describe-env foo", 1)
    assert_equal expected, output.chomp
    config.mkpath
    output = shell_output("#{bin}/sceptre describe-env foo", 1)
    assert_match "yaml", output.chomp
  end
end
