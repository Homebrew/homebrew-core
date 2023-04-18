class Woob < Formula
  include Language::Python::Virtualenv

  desc "Web Outside of Browsers"
  homepage "https://woob.tech/"
  url "https://files.pythonhosted.org/packages/bc/6b/007a19a00f8156c8c4d18abbe4d0a81bc2669b564f37e69152cdc73db72a/woob-3.5.tar.gz"
  sha256 "2fd14125cca51ffbdf9a9bd32a7a1f7e8241e5a264b732e7e4ca1b4358734d9d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e42804a3b5700181fe1c3e02388cc4e54877daf87836ebb8d5a70e2f7c45d297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "613ef659cc4e9a4eee32e17677e484b563f230214c1dc079b30d41ec9e101578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca788b9db92f8cfa4bcc44b54475b282bc50a1f6eed540e9875a1984f5d4c63e"
    sha256 cellar: :any_skip_relocation, ventura:        "17f44bf0331b1e7a35a3fc885d8b6138c0f65208a9bf8e859c9dcca4b6caae54"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbefb4a195bae0451f5aac48043f8dcbbbcbc30346c58ad4e9c0b08f543d4ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d456d40f9d7d2ad30ea64be0862a3b2b56e9b188e52c77e900611a967d8d037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a6876ba4b9560bc002b0f2336df8d1111e77f8c410923b2784eb69c983e602"
  end

  depends_on "gnupg"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/6c/f9/033a17d8ea8181aee41f20c74c3b20f1ccbefbbc3f7cd24e3692de99fb25/html2text-2020.1.16.tar.gz"
    sha256 "e296318e16b059ddb97f7a8a1d6a5c1d7af4544049a01e261731d2d5cc277bbb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/0b/25/37c77fc07821cd06592df3f18281f5e716bc891abd6822ddb9ff941f821e/Unidecode-1.3.6.tar.gz"
    sha256 "fed09cf0be8cf415b391642c2a5addfc72194407caee4f98719e40ec2a72b830"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def python3
    "python3.11"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-woob.pth").write pth_contents
  end

  test do
    system bin/"woob", "config", "modules"
    system python3, "-c", "import woob"
  end
end
