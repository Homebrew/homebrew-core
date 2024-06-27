class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/03/9e/ae012a5e563c1e2f948af367518ae2bc4a3ebdaecf9efdb79058c775e653/trafilatura-1.11.0.tar.gz"
  sha256 "9334ca101c40b2904af5afcee790f0374fabca3ac388811720be65cc768787a2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2247edf98598adbb5d70ce94a1827ee7d802d57bb38c3d667eacd2a30c7fd0bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd57aa2496623b77f41a5dc4a4f877c608edfa5371017fa18402c6804c198777"
    sha256 cellar: :any,                 arm64_monterey: "b4ce4d772797b0d53d38a548f8b066130cd75ae434bb1d29d4abe11ef1f624cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b40a3133ae6981986c79052c5fa9ea4989dc3b332020d8d4791863221d0c30"
    sha256 cellar: :any_skip_relocation, ventura:        "f2eb82c266b43b9f01c2e035b1e8fbc7654f0800d39121fe95f91574579bd485"
    sha256 cellar: :any,                 monterey:       "32dc85b9b44302c31d1075ec59fc08792f982263c1ab7b74044cc69bade9acdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8097367fc91e179140cc7614cdcc9d59876099c43447d59a349006d8bcd67071"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/15/d2/9671b93d623300f0aef82cde40e25357f11330bdde91743891b22a555bed/babel-2.15.0.tar.gz"
    sha256 "8daf0e265d05768bc6c7a314cf1321e9a123afc328cc635c18622a2f30a04413"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/97/8d/4f435e4e93a30acce11da3c98579273ba463e27d9988ed84384a574396fb/courlan-1.2.0.tar.gz"
    sha256 "0cbc9cac83970c651b937a7823a5d92cbebb6b601454ea0fb6cb4d0ee5d1845d"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/cd/71/ac70cf10ea9b58414a0d8d32593f916ab83e0d9d28c95e91879d26cffd0d/htmldate-1.8.1.tar.gz"
    sha256 "caf1686cf75c61dd1f061ede5d7a46e759b15d5f9987cd8e13c8c4237511263d"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/b1/59/93ce612fce25c274efc88ec4d65963ce80fce96b9048e9fc1e430d893a9e/justext-3.0.1.tar.gz"
    sha256 "b6ed2fb6c5d21618e2e34b2295c4edfc0bcece3bd549ed5c8ef5a8d20f0b3451"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/07/51/37862bf64cd8d5b5675755ac071de7eb2e780c0c0079e02b57c289a25399/lxml_html_clean-0.1.1.tar.gz"
    sha256 "8a644ed01dbbe132fabddb9467f077f6dad12a1d4f3a6a553e280f3815fa46df"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
