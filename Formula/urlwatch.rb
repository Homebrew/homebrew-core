class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/e1/1d/283de30cfc04c3601fc73eca4f1b2a5cb5a25a9fa715eb2bf9678ab45d0d/urlwatch-2.25.tar.gz"
  sha256 "6802297d3318286e7f3d36b9a4567a2fb09b0ae779d4b76811dd29a7281c1f8a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619ffda835825661550d80582bd56406970dc69a8ac0b7449f193dee69c516fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca9d759339d34019e94cea3c504a1cd466684b956cced245cb4feae520611a2"
    sha256 cellar: :any_skip_relocation, monterey:       "06fa62b4d98bee01fd7525c02f5c3465008f9180d5764ac2a8cbaaef23338dc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d86c126acfee884cdb2c4b3bcf8db16c14ca3db41e0f070c88a7d6657beb9f3b"
    sha256 cellar: :any_skip_relocation, catalina:       "c7dc45887a538bd5b92e8bea612b500676f711a9d9e1976bb5a3f596de22444e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50fead7616594e7aaf9dd195f8d0711ede0230a98ed102561bc792e1a71466f2"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a4/9e/9d9eb6a6dc4f347bae8200a2e1dd65a7b96ae99e29ef8f7452ccc4ef9eea/keyring-23.6.0.tar.gz"
    sha256 "3ac00c26e4c93739e19103091a9986a9f79665a78cf15a4df1dba7ea9ac8da2f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/21/75/2356bd4dcc48a8af77b0d2ded8984ceba5e4c71f67e9734ec9e378467ebd/minidb-2.0.6.tar.gz"
    sha256 "8bf0aca9b89cb1e8b7bfd8ad8b5a7208bd2fb046e343b3d656ea00f8bcfd6f5e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end
