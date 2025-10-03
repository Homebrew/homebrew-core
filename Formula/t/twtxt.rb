class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/fc/4c/cff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756/twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac01d94b2e9e13b01afa2131612096aaad0b554289a66561f379a03f638697d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29cc2de20dc895c385ac0a63e44855b00dbde6e2bc5731b8a2e1a7cfc032e928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b10bcf1dbbaab2d9a31cac9ac6aeace17f927b3962940c772229213675f1de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45ccbfb3032ae02b0c63bb81cb193951b02686289a3c9587b7ef4f2ff1555e4e"
    sha256 cellar: :any_skip_relocation, tahoe:         "1fdfedf772bd24d132bbd7aadcda7f1971c2f8f4783c738ca4cf3e709b8d9006"
    sha256 cellar: :any_skip_relocation, sequoia:       "657122f063434a21eda3925652a7308c196fdef8cb9f492aa758142fa76097f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d70b5429efc89db1aa8820be9b1d89a7a80d9e4c139279650529006ba071d5a6"
    sha256 cellar: :any_skip_relocation, ventura:       "38eba811f1499a3bfe7ee08315da847d3cc9c2f83e26fec1c321bb5736042a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a929882929f239219e1e9325a9dd9a845a3a811467b470db31d7e4e0cc984e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abcbe4536337494e6441e9d3abbbe8d16de129ca6a9f37096f3e5fe5344718ce"
  end

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/e6/0b/e39ad954107ebf213a2325038a3e7a506be3d98e1435e1f82086eec4cde2/aiohttp-3.12.14.tar.gz"
    sha256 "6e06e120e34d93100de448fd941522e11dafa78ef1a893c179901b7d66aa29f2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/22/d1/bbc4d251187a43f69844f7fd8941426549bbe4723e8ff0a7441796b0789f/humanize-4.12.3.tar.gz"
    sha256 "8430be3a615106fdfceb0b2c1b41c4c98c6b0fc5cc59663a5539b111dd325fb0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/3d/2c/5dad12e82fbdf7470f29bff2171484bf07cb3b16ada60a6589af8f376440/multidict-6.6.3.tar.gz"
    sha256 "798a9eb12dab0a6c2e29c1de6f3468af5cb2da6053a20dfa3344907eed0937cc"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  # Drop setuptools dep: https://github.com/buckket/twtxt/pull/178
  patch do
    url "https://github.com/buckket/twtxt/commit/12bdd3670bff339fd27a7cd71c8ec64086b4ae5b.patch?full_index=1"
    sha256 "e206e7d18040d2b6c0d93ef2d7e4770c3e24448621bc6b5e0f206e193c6298ad"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"twtxt", shell_parameter_format: :click)
  end

  test do
    (testpath/"config").write <<~INI
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      brewtest = https://example.org/alice.txt
    INI
    assert_match "✓ You’ve unfollowed brewtest", shell_output("#{bin}/twtxt -c config unfollow brewtest")

    assert_match version.to_s, shell_output("#{bin}/twtxt --version")
  end
end
