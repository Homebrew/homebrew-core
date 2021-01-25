class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/78/eb/a48c359b32ad81e6c5ea0141ef9139859ef43dc4640d5ced721bba4ae1cc/yubikey-manager-3.1.2.tar.gz"
  sha256 "7709c83aebb443259197a452772430edd1ac019e31a57a71ea33a90a4a7879f1"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "bdefdcfbdd17e876b92ee3405b79b094955ae2b597d1839ecbf3ef1e2cb48936" => :big_sur
    sha256 "0fc39d2fd810b8f6eb193e7f7e8104a9e8e3227c6262e15d60cbea7e1a862162" => :arm64_big_sur
    sha256 "d58e6fa495a5e5cd405cb651bdcdcc783c179b3817a0469ab19c88b3f0153c29" => :catalina
    sha256 "bd8606fe932c56e86dbfe1ee4c920626e807bdc3e06e2f4a579ce32d39d14c6c" => :mojave
  end

  depends_on "swig" => :build
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "ykpers"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/b7/82/f7a4ddc1af185936c1e4fa000942ffa8fb2d98cff26b75afa7b3c63391c4/cryptography-3.3.1.tar.gz"
    sha256 "7e177e4bea2de937a584b13645cab32f25e3d96fc0bc4a4cf99c27dc77682be6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/97/03/9ce85396423a4b9897cc3295a605b63dffd06940e65c1cccd51c2c016864/fido2-0.8.1.tar.gz"
    sha256 "449068f6876f397c8bb96ebc6a75c81c2692f045126d3f13ece21d409acdf7c3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/2b/98/fd2a827eed42ca3dcd7a433ee75a9868bfe3fc1428839a2831ab9dd90c69/pyscard-2.0.0.tar.gz"
    sha256 "b364d9d9186e793c1c4709eb72a4d29e09067d36ca463b2c2abd995bd1055779"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/b9/8d/25c4e446a07e918eb39b5af25c4a83a89db95ae44e4ed5a46c3c53b0a4d6/pyusb-1.1.1.tar.gz"
    sha256 "7d449ad916ce58aff60b89aae0b65ac130f289c24d6a5b7b317742eccffafc38"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
