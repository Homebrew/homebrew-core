class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/fc/4c/cff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756/twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "733337de91c23b4e1c75a87f0250d2180427d4628e199adc4eb5cb9f9882c9ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc5b8ff58fe0e1e02d3253b8962f0abfffb5ed1653bd13ac757eef949a52a3a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ae2cefd0bc65eb2961c5a98ccb41e0a62fb8d5b0019d2b6d77228b5839fe0f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8ba67c7476f6ad425de2dcf66606fe6ab54dadc4b6eaf5e20296e190fea320b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e847b668b00a76c17e708fa676e8cb33be4ee2695da3c6e6eeaf1d04fe37654"
    sha256 cellar: :any_skip_relocation, monterey:       "c2a42801bd4271d75dfe7949c96b3036e7d7325717d2af1438aacc1791ce7d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe280f8838cf7f42f3b71325d75e40b49afc5c09986b554b6c2a9019e9e1e9ac"
  end

  depends_on "python@3.12"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/7e/0b/4235b25496c741f4c9f75a94951fbc15c48537349a03448687fb226256ef/aiohttp-3.9.4.tar.gz"
    sha256 "6ff71ede6d9a5a58cfb7b6fffc83ab5d4a63138276c771ac91ceaaddf5459644"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
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
