class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/9d/27/2f40f6b7ffc5f4e36da4d75780d818f3b74fb5394f2b043b04cd34bf1ecc/yubikey-manager-3.1.1.tar.gz"
  sha256 "68ef41ac3cd2e891019e755a492427ecdd63d8816525d05f2f32c37b8c440cfa"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/Yubico/yubikey-manager.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "7e4c71dc6d2c85204e4e0adec57ecf2600e9b6805438f7f1dbb28f589b7eb6d3" => :big_sur
    sha256 "52b8348e1263cdf8e51b06dd40085e3aef2be9d154355add21e99ba1e6660146" => :catalina
    sha256 "6cdee1b430e53d5a3e2eec0d978bd6e2e6039e9afd31a80267b79cc4a11a6e85" => :mojave
    sha256 "5ae0a850fab23bcabf5df6ed14ddd95568430bb6374777c637abecb805b26581" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz"
    sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/97/03/9ce85396423a4b9897cc3295a605b63dffd06940e65c1cccd51c2c016864/fido2-0.8.1.tar.gz"
    sha256 "449068f6876f397c8bb96ebc6a75c81c2692f045126d3f13ece21d409acdf7c3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/ed/dd/c575bb75122c250cbed3f70440cb8e25582bf991855bb4eb27371fb8d962/pyscard-1.9.9.tar.gz"
    sha256 "e6bde541990183858740793806b1c7f4e798670519ae4c96145f35d5d7944c20"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/5f/34/2095e821c01225377dda4ebdbd53d8316d6abb243c9bee43d3888fa91dd6/pyusb-1.0.2.tar.gz"
    sha256 "4e9b72cc4a4205ca64fbf1f3fff39a335512166c151ad103e55c8223ac147362"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
