class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/79/b2/ad3e32b9eb3c86fa26710e4fa260941f1635058f5203d6172512cf40aa2b/vsts-cli-0.1.2.tar.gz"
  sha256 "a116949e7afe1a0164d19671b79f2b72eca3f4d893180c1a83aa9a4885e3a568"

  bottle do
    cellar :any_skip_relocation
    sha256 "c951feffa80d1d1bab578373d692cb8e46beef1d98cf80f57a3e2d55f91ae5cc" => :mojave
    sha256 "f581e56644210416738424264db59d1264e40959d7a24dc762fce10b385f3650" => :high_sierra
    sha256 "42ffbe7062e59f34521e7a52edccf259effa972aa531af52b9d908bd642d6cc2" => :sierra
    sha256 "a674bcfe820a9fb00c765968a3076abf8f7e1e639ee55cf9dd5c7536940c276c" => :el_capitan
  end

  depends_on "python"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/21/9741e5e5e63245a8cdafb32ffc738bff6e7ef6253b65953e77933e56ce88/argcomplete-1.9.4.tar.gz"
    sha256 "06c8a54ffaa6bfc9006314498742ec8843601206a3b94212f82657673662ecf1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/0d/2d/8cb8583e4dc4e44932460c88dbe1d7fde907df60589452342bc242ac7da0/humanfriendly-4.7.tar.gz"
    sha256 "ee071c8f6c7457db53472ae9974aaf561c95fdbe072e1f2a3ba29aaa6ca51098"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a0/c9/c08bf10bd057293ff385abaef38e7e548549bbe81e95333157684e75ebc6/keyring-13.2.1.tar.gz"
    sha256 "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/b5/58/2ba172d2ea8babae13a2a4d3fc0be810fd067429f990e850e4088f22494e/knack-0.4.1.tar.gz"
    sha256 "ba45fd69c2faf91fd3d6e95cec1c0ef7e0f4362e33c59bf5a260216ffcb859a0"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/d9/48/e636320da2f5ebf2a0786af61f9656ede1448f57b5b8d1a232e313fc5081/msrest-0.5.4.tar.gz"
    sha256 "d609c2997ab66aa8985a6ced972e895cd7aa0a415d715af042a554c5c791934a"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205/requests-oauthlib-1.0.0.tar.gz"
    sha256 "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/2a/7d/b4fba9ed02c7628f7102bb8c9f600403168eede973bcdc44abc017a1cf91/vsts-0.1.15.tar.gz"
    sha256 "7185ffff8e30a05011dd0bea1da468e44da40da3d013ddbcc541cbf51b7a916c"
  end

  resource "vsts-cli-admin" do
    url "https://files.pythonhosted.org/packages/00/c1/2c5e0d636673c89a527de0bb23a1312ffbf12816f75e167927b1dd6bb1a9/vsts-cli-admin-0.1.2.tar.gz"
    sha256 "7129081f6bd4015758c75331a6a0fdfaf6d56f50d2f0de5d0e54999645d00859"
  end

  resource "vsts-cli-admin-common" do
    url "https://files.pythonhosted.org/packages/31/b4/b12c64b8f272453e8465933c18c90298eb9dfd7c52da6d84e64de0548a73/vsts-cli-admin-common-0.1.2.tar.gz"
    sha256 "c8dec61a91820f4674700b54ff24828cb67fbf49ed96f0c771f9bb6bfa969da1"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/6b/3d/21afd6a855807ab64b172649f80f9e47fb79a7b60ed4f32b7d0c49fa291f/vsts-cli-build-0.1.2.tar.gz"
    sha256 "6fa499bf44da76325fa485670578bf9613a9dbc0d0290c65850813ef2f010e2a"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/aa/01/f7c09bf4030464a54a19339e4125951c6de86483c679fee27390a588c96b/vsts-cli-build-common-0.1.2.tar.gz"
    sha256 "df583da1dcda5cf25e2518c6cea10a7b0d1aedbe2be849e8dc9c026ff4ed85e6"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/d9/3c/db397b69f5ba72a04fe54a26045e800d310fad59f2a922561b721c629721/vsts-cli-code-0.1.2.tar.gz"
    sha256 "e88d7d2b29b5f0322b5cca38e17285b3d56b71bd23ec513a8613a99b5e9435d6"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/47/0f/ff37edcda5003663052f4452664d7493e42302ca4798faa58f09cdd64948/vsts-cli-code-common-0.1.2.tar.gz"
    sha256 "a3da92b4efda1f2a8e5af37a08644591d1d33e205f25a34c6efb9125b51f4e8d"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/97/f9/5d569fe756866f3c427d922e159f259b34be01710adf41cadca144041437/vsts-cli-common-0.1.2.tar.gz"
    sha256 "520324c8f5503e7986ec14b8d5043586d2e78fb3ad0c11cc068de86f77c306ef"
  end

  resource "vsts-cli-package" do
    url "https://files.pythonhosted.org/packages/ec/52/0ef94152f04ce57a4b306d0b80e1ed848d460c242cfd894ffac550bdf681/vsts-cli-package-0.1.2.tar.gz"
    sha256 "0ed965f837661b4363550b9d39c1633e443b4e352cd97bdd7671ba3b5c1021b4"
  end

  resource "vsts-cli-package-common" do
    url "https://files.pythonhosted.org/packages/a5/e6/759fcc6c1c8bf0cca6c0bbb9201184f6feb21162e0560735e4f854c8a674/vsts-cli-package-common-0.1.2.tar.gz"
    sha256 "ba1a409d5c7e69ac284478b569ab2cd9be88dd81cefb84e687bd5ce9aee29fe8"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/7f/a9/1a6f5cdde00e4164a00c89d28ccd075d9267f7d3773b35a3ed26abd0ae82/vsts-cli-team-0.1.2.tar.gz"
    sha256 "d1c318321c4e32d232fa2e8c72aea46a2b4076b72c1282d14939ab3b0eaf6e95"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/66/08/47be930285c1d9933edfca2478818a297340eb66c89305e6c10d2ed78b2f/vsts-cli-team-common-0.1.2.tar.gz"
    sha256 "8898fffa89a24caad2f3a484b4d097defe0b91cde821c40441048a548a4d8928"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/93/87/f035812106a0b0e5bda793c07e4fa7f844d34de016d33fa409a06266fed9/vsts-cli-work-0.1.2.tar.gz"
    sha256 "993ea15ecdbb9682aaa4a7de5cb2f2d13283f38db934b669f01432b23c868ee6"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/c6/c8/d275b53169d62a212c0ec99bd2d66e3b73ffa2163824137c40e50eadcaba/vsts-cli-work-common-0.1.2.tar.gz"
    sha256 "a0d0c526a14e9c5c75fc2030f68f54db329d01401711e03cd84dfb36daefcb2b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/vsts", "configure", "--help"
    output = shell_output("#{bin}/vsts logout 2>&1", 1)
    assert_equal "ERROR: The credential was not found", output.chomp
    output = shell_output("#{bin}/vsts work 2>&1", 2)
    assert_match "vsts work: error: the following arguments are required", output
  end
end
