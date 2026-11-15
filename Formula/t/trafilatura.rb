class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c3/e7/d359fcf887675c4305fb1f4548372484a2d8f0bc793dc6f2da3a748c1253/trafilatura-2.3.1.tar.gz"
  sha256 "2e5557aeab32d33b9da7ff0debbb677a676c5b648a927e50d91b8277011e1105"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77a6011c5f679152a505a87bad6de8f592222b997bcc8030e69d03a64a183506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02384a585e5bc23d663504df1739f03376e310bea431e976239f8771f4c0c0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd665903a089e5ff141399c2bd81e083bb98301af976a8d7ec6e9263324e8750"
    sha256 cellar: :any,                 arm64_linux:       "49fc8b15450adf1e5e9d12e043604fe41a7a7e678a10a8129456d8568fa9edd2"
    sha256 cellar: :any,                 x86_64_linux:      "3416f7f73e499e63d1bd227f02b36a06b396f40ca3cca6d782697ad8ec3a29fb"
  end

  depends_on "certifi"
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/bb/16/2a771612ee0b3acaa95ac21cc7e8a3319e815d6360f8ffc5987d1ce28499/courlan-1.4.0.tar.gz"
    sha256 "fbbac7b7fcde2195ea08e707609503c81cf39c891e8d26cdb1fed4585782d63d"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/c7/5d/bd21ba1519b6b1e222b29878301d2e1fb928e890dc7d085fa4222ac5671b/dateparser-1.4.3.tar.gz"
    sha256 "bab8c43a746266e68142f4926e69438ce551441aa88e54e78bb6410bf3ee7000"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/44/4d/3303caa82c75cd81e43d81906fa0f57c02c1e2e92ef9a3709cfe57fa678a/htmldate-1.11.0.tar.gz"
    sha256 "e099a58143d5ff32471f2aa8770247e12f0f5bdff62f2df74f833277fd0071b6"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/49/f3/45890c1b314f0d04e19c1c83d534e611513150939a7cf039664d9ab1e649/justext-3.0.2.tar.gz"
    sha256 "13496a450c44c4cd5b5a75a5efcd9996066d2a189794ea99a49949685a0beb05"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/0a/63/195dfdde380a84df309e3bccf4384b034b745dba43426886f7ae623b4fba/lxml_html_clean-0.4.5.tar.gz"
    sha256 "e2a4c7d5beedd17cd7b484d848a0571e54baa239a4f9df5546e3acba7f990560"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/14/21/d83d6ef28c4c912c4bb4d1dcf591f7b8c6bde87b9c66f9f454677314e16d/pytz-2026.5.tar.gz"
    sha256 "fa23724b9c486543b9ff54a327ee7569ac83ade54bb9afd0fc18676620401c86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
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
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
