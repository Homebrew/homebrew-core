class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/28/3f/1d11375431bbcd8d42dc2014d742f0b836102213dfa16390036b63c43a52/trafilatura-1.10.0.tar.gz"
  sha256 "7b10573e2dd16b6702f56f56858b25f34ff81d6b16e429af0a3b266f0746aeee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6deaca039b59d307e2d65f06f4b584eb59cdb9d892ca53cddc3f46989992eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdacc5616a548ece68e90b7f9462654563857ebddf8a00699b434d4d3958f857"
    sha256 cellar: :any,                 arm64_monterey: "5a77bd525905f8b3c0474cad068abb2ccf05bbbb1e4aac9a7806cc782e0e1d15"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae77353870dd393719e652e72e8ab18b411f044f8b6ceb543dbf0ba878973748"
    sha256 cellar: :any_skip_relocation, ventura:        "9cd8ee23c776a852c642bce3993b16c12614d5160971517e1d59efa1066a3cf7"
    sha256 cellar: :any,                 monterey:       "d3b2477cace5db7016fd3c09b28a2380ef9342e3c4e449fd3a5d2f9f38a57d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ab531463668f276420fed5cdf50afd07cfad867ec0cf8f87155eff93e69ca3"
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
    url "https://files.pythonhosted.org/packages/9e/e8/66d9e87a5db4d627d4961c68d121b12b99b205e2f9d73aa3118ab9815236/courlan-1.1.0.tar.gz"
    sha256 "d706684334f18be4ada1fbd57f2680adf0036648f6d840852f7a4822d3adfd8d"
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
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
