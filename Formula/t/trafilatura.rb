class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/06/25/e3ebeefdebfdfae8c4a4396f5a6ea51fc6fa0831d63ce338e5090a8003dc/trafilatura-2.0.0.tar.gz"
  sha256 "ceb7094a6ecc97e72fea73c7dba36714c5c5b577b6470e4520dca893706d6247"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ee4bf4121a57dcd514aaf8c87891d01e6f8f2d854c0b1e86184edd3e8ea4eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ab9f5a751d6c595f1dd3e9f345c5a7a18819c4e0878834f26b319fedb8e0d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8dc29923fe52f8bff8e6407987348b863d6f9842322a6842bda107582d13a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2401490c4582d74d08d921bce9c8c2ce56027d93ac9b4d81f29e6e02f89af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8953668c7b0601c74c4ae93f3915cee54fa16974bc4f5bc3a2344b8f0b0e8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01772f935730cffe0e446d8b11915816916793de7c5574e22fc378473df05d7"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/6f/54/6d6ceeff4bed42e7a10d6064d35ee43a810e7b3e8beb4abeae8cff4713ae/courlan-1.3.2.tar.gz"
    sha256 "0b66f4db3a9c39a6e22dd247c72cfaa57d68ea660e94bb2c84ec7db8712af190"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/46/2d/a0ccdb78788064fa0dc901b8524e50615c42be1d78b78d646d0b28d09180/dateparser-1.4.0.tar.gz"
    sha256 "97a21840d5ecdf7630c584f673338a5afac5dfe84f647baf4d7e8df98f9354a4"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/9d/10/ead9dabc999f353c3aa5d0dc0835b1e355215a5ecb489a7f4ef2ddad5e33/htmldate-1.9.4.tar.gz"
    sha256 "1129063e02dd0354b74264de71e950c0c3fcee191178321418ccad2074cc8ed0"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/49/f3/45890c1b314f0d04e19c1c83d534e611513150939a7cf039664d9ab1e649/justext-3.0.2.tar.gz"
    sha256 "13496a450c44c4cd5b5a75a5efcd9996066d2a189794ea99a49949685a0beb05"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/9a/a4/5c62acfacd69ff4f5db395100f5cfb9b54e7ac8c69a235e4e939fd13f021/lxml_html_clean-0.4.4.tar.gz"
    sha256 "58f39a9d632711202ed1d6d0b9b47a904e306c85de5761543b90e3e3f736acfb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/56/db/b8721d71d945e6a8ac63c0fc900b2067181dbb50805958d4d4661cf7d277/pytz-2026.1.post1.tar.gz"
    sha256 "3378dde6a0c3d26719182142c56e60c7f9af7e968076f31aae569d72a0358ee1"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/5c/5d/76b4383ac4e5b5e254e50c09807b3e13820bed6d6c11cd540264988d6802/tld-0.13.2.tar.gz"
    sha256 "d983fa92b9d717400742fca844e29d5e18271079c7bcfabf66d01b39b4a14345"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
