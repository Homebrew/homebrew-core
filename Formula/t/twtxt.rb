class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/fc/4c/cff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756/twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4f590cb712a3df1920c24f4eab27a5775e01702bef740e6cd3dbf5d3596eaa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8202e4442858187e3e78a0ead54890f0f6e8c681f8d1e91cbe9aeb65d115b2c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d3f2b6c60aec97df3908b7b48ce711188ca04623d126153a720577a20087cdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4bf94444aa2abc531ca49e18f5ad989d88bdaab09b16b40f73922ad85ff0933"
    sha256 cellar: :any_skip_relocation, ventura:       "bd61d7a65299a58049997b26c0c1850c755bc8038522553db783d7b0789a3a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c620715d8bf674f13d752dc56fef8dbfe5db2d51ed51012fe289917772c72a1c"
  end

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/17/7e/16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141/aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/6a/40/64a912b9330786df25e58127194d4a5a7441f818b400b155e748a270f924/humanize-4.11.0.tar.gz"
    sha256 "e66f36020a2d5a974c504bd2555cf770621dbdbb6d82f94a6857c0b1ea2608be"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/46/fe/2ca2e5ef45952f3e8adb95659821a4e9169d8bbafab97eb662602ee12834/yarl-1.14.0.tar.gz"
    sha256 "88c7d9d58aab0724b979ab5617330acb1c7030b79379c8138c1c8c94e121d1b3"
  end

  # Drop setuptools dep: https://github.com/buckket/twtxt/pull/178
  patch do
    url "https://github.com/buckket/twtxt/commit/12bdd3670bff339fd27a7cd71c8ec64086b4ae5b.patch?full_index=1"
    sha256 "e206e7d18040d2b6c0d93ef2d7e4770c3e24448621bc6b5e0f206e193c6298ad"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"twtxt", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"config").write <<~EOS
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      brewtest = https://example.org/alice.txt
    EOS
    assert_match "✓ You’ve unfollowed brewtest", shell_output("#{bin}/twtxt -c config unfollow brewtest")

    assert_match version.to_s, shell_output(bin/"twtxt --version")
  end
end
