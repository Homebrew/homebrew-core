class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://files.pythonhosted.org/packages/73/78/efb0e0cc6715ccbfdbd82e802c0f394bd8794d159b0998d5d60b4250b702/sops-1.14.tar.gz"
  sha256 "3af953198e54c9564b74f35c937ec230365a74c3659c720e083422103e064a9e"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any
    sha256 "e088165ec84dd3fc5ce81e4d0069c543ec2a1de5d4b68ecea11325d526ca33e6" => :sierra
    sha256 "14506bfebac13b4816cbfd4db88e88db3862b170c266161c9ecf2b8ba2232cf3" => :el_capitan
    sha256 "a315c1b4f41d5c7f6aaa833991dcc22c662dfdfc039369aa2b612648f016d361" => :yosemite
    sha256 "2e34954c20bc5b1137073990ef472d8574e979deb399112533a14558952a3e22" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/37/1a/e271b2937c05c1da265415103725e0610fb96871a2d7ddf68b999ac5db8f/boto3-1.4.0.tar.gz"
    sha256 "c365144fb98d022ad6f6cdeb1abf8a4849f1a135e3c4ef78ef5053982ed914b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/75/ee/bb8c43101456225c0a7ec916878230780d49f75d701a4e96beb2bfa606aa/botocore-1.4.54.tar.gz"
    sha256 "5cf7220c8ccadf6d1424be580cfa7c716693a52156cb9ac40dae28b9a894b095"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/b8/21/9d6f08d2d36a0a8c84623646b4ed5a07023d868823361a086b021fb21172/cffi-1.8.2.tar.gz"
    sha256 "2b636db1a179439d73ae0a090479e179a43df5d4eddc7e4c4067f960d4038530"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/8f/d8/6e3e602a3e90c5e3961d3d159540df6b2ff32f5ab2ee8ee1d28235a425c1/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "ruamel.ordereddict" do
    url "https://files.pythonhosted.org/packages/b1/17/97868578071068fe7d115672b52624d421ff24e5e802f65d6bf3ea184e8f/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/f0/85/36931437a58010067837946bd31823072c827657e1a3c50ba5f4848163d4/ruamel.yaml-0.11.7.tar.gz"
    sha256 "c89363e16c9eafb9354e55d757723efeff8682d05e56b0881450002ffb00a344"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a3/e9/24937eaf1ffccb5f7861b24b45cd3ef13c09e21f6932466cc2862021ab70/s3transfer-0.1.4.tar.gz"
    sha256 "c41d039ab9204e9eea72a6098ca5092ed001f2820274b80be622dbe582ab2d41"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
