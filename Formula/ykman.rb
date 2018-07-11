class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://developers.yubico.com/yubikey-manager/Releases/yubikey-manager-0.7.1.tar.gz"
  sha256 "177bbf953b8557b8de68bacbbdfc56764e93733f337b2327e322cfc4ed4f7d18"

  bottle do
    cellar :any
    sha256 "e17ca0a4bede88f9824b0ab8a4e4c8992fa48ae4383a821ae7d4510c038a0f0a" => :high_sierra
    sha256 "8151695ec7ab580143a80b612b5254399aefdbc6b63cd6723cc0a757d1682349" => :sierra
    sha256 "c27eb7ae105f8d61f956bef5da55c0b5f06eb66485f93a62dc9831b99daf80ca" => :el_capitan
  end

  head do
    url "https://github.com/Yubico/yubikey-manager.git"
  end

  depends_on "python@2"
  depends_on "swig" => :build
  depends_on "ykpers"
  depends_on "libu2f-host"
  depends_on "libusb"
  depends_on "openssl"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/28/4d/82131eee1b9f95d6c06a87ab03c075b8a36b2772b0cf825d522a7e8bb503/fido2-0.3.0.tar.gz"
    sha256 "32c0db375458853d68cbbeb04861c412a05c22c873236a0c4f71296dc983ab35"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/17/f3/e6e52e3dab39b26450d9fb6385c4a40f883180d6f1ee26ad4567dd243edc/pyscard-1.9.7.tar.gz"
    sha256 "412c74c83e7401566e9d3d7b8b5ca965e74582a1f33179b3c1fabf1da73ebf80"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/5f/34/2095e821c01225377dda4ebdbd53d8316d6abb243c9bee43d3888fa91dd6/pyusb-1.0.2.tar.gz"
    sha256 "4e9b72cc4a4205ca64fbf1f3fff39a335512166c151ad103e55c8223ac147362"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
