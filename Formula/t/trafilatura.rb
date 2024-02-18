class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/37/91/d9f06ae3a34e2c110ee0574d80df7166354b821e6881a9d67771836b5b3f/trafilatura-1.7.0.tar.gz"
  sha256 "a166e67f005a6a12ef194f48c7c9fa4e1b0e36756fdd2b64e02473c356962f04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55eb840150259e4651e237d4ebf0cbb3b9896d648eb770fab2a260540e145198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8270e06dbd76492910549c8351f05775f2487a81b7b39cda3c673e470661ab93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e46442ce16b0237142db024ebff9273eaa4d6d4bcdb5af929ea8881af1b387"
    sha256 cellar: :any_skip_relocation, sonoma:         "35fa128bb8400165aa141c18172383cf7c6865a05b1060449561c4b74034ab1e"
    sha256 cellar: :any_skip_relocation, ventura:        "462dc93363b9ca33d0287521a3a3d1b3907b5f29097e999b8cec8b45db82d3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf743517af6853408b8ec58da1c7bcf6b0057cfc4a242d1dc2e4d2725aa813f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebee2433c6d3e0949e4cd2e8f90ffe48b7cb3cc5b8d9d6bd0ec1292a626b383f"
  end

  depends_on "python-certifi"
  depends_on "python-charset-normalizer"
  depends_on "python-dateutil"
  depends_on "python-lxml"
  depends_on "python-pytz"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/dd/66/09e441e9130ea67201009b3e6020ebccf2c90df4a25a05edd79f08706d33/courlan-0.9.5.tar.gz"
    sha256 "38dc35b2e3bf1f5d516d00d51ac12ebde543e3417c6be6f6a2273c0fc5b5b353"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/37/19/5ffad26ca43d2d2e3f360e24e58b1fc55b123ffc4fe5758070c8202fec47/htmldate-1.7.0.tar.gz"
    sha256 "02a800dd224cbf74bf483b042f64e14f57ba0e40c6b4404b284e98bc6c30b68d"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/80/6f/72e69f69ae55a9e7d8a1b1a5c8f809ccc615ca0a16dee2ce0ca48dc32dc9/jusText-3.0.0.tar.gz"
    sha256 "7640e248218795f6be65f6c35fe697325a3280fcb4675d1525bcdff2b86faadf"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/5f/ec/9955d772ecac0bdfb5d706d64f185ac68bd0d4092acdc2c5a1882c824369/langcodes-3.3.0.tar.gz"
    sha256 "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
