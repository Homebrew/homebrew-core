class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a5/81/f7818b3d805427e8448429fd1bfc126a06b2e5daa58ea97a8b153e5454fb/trafilatura-1.6.2.tar.gz"
  sha256 "a984630ad9c54d9fe803555d00f5a028ca65c766ce89bfd87d976f561c55b503"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb655222f553828660fffb11a82cfb0d0c9af7a04d97feac739d54a84483fa02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd26bf1c9c992616100533d175bba971c9f0a3e6b0f9f7f3ed10f46795c6b0df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fa1cbec8369bd8b7a2023900df32c19ff6c35705984fdfdbebb3fb5bf4ed306"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fe47932f4e8a8c4d9044a504d7e5c6b6663ffba61cafb45c31314f828d892ca"
    sha256 cellar: :any_skip_relocation, ventura:        "de704a0e552ffb6e3b0a4a7dc3b360f5846eb2beb855545466c7b223d0ef92fd"
    sha256 cellar: :any_skip_relocation, monterey:       "99520d29f0d1dbd54ccab6a307ab2b975cc59b5604480adbf719c2f7ba855f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00aa677ea4daa982c48ae3cbb862b3a30818118ac1022f3a4358e1afe74a7c35"
  end

  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/53/35/d141b5ffc381cef94c95d32d7082aff443cfea22b2a75c2839297064d408/courlan-0.9.4.tar.gz"
    sha256 "6906aa9a15ae9d442821e06ae153c60f385cff41a8d44b9597c00b349f7043c5"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/eb/e7/734003a0f198347fa7f95b5edb3e02a9d22e42df5f2f96261366fe7f220e/htmldate-1.5.1.tar.gz"
    sha256 "00530d34618b6e770df537e6a8be74d8359ffe2cc5ee86e06ef20990049b6db6"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/80/6f/72e69f69ae55a9e7d8a1b1a5c8f809ccc615ca0a16dee2ce0ca48dc32dc9/jusText-3.0.0.tar.gz"
    sha256 "7640e248218795f6be65f6c35fe697325a3280fcb4675d1525bcdff2b86faadf"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/5f/ec/9955d772ecac0bdfb5d706d64f185ac68bd0d4092acdc2c5a1882c824369/langcodes-3.3.0.tar.gz"
    sha256 "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
    sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Search\nImages\nMaps\nPlay", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
