class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/4f/6d/9289eef4bf97702b2538745cd5ff89ea6c5af7b2694acb34db94c0c9f340/vsts-cli-0.1.3.tar.gz"
  sha256 "49a02db989b1e311379c397bdd3572fd243b8d5068bbba5963ca56602a6f72e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c951feffa80d1d1bab578373d692cb8e46beef1d98cf80f57a3e2d55f91ae5cc" => :mojave
    sha256 "f581e56644210416738424264db59d1264e40959d7a24dc762fce10b385f3650" => :high_sierra
    sha256 "42ffbe7062e59f34521e7a52edccf259effa972aa531af52b9d908bd642d6cc2" => :sierra
    sha256 "a674bcfe820a9fb00c765968a3076abf8f7e1e639ee55cf9dd5c7536940c276c" => :el_capitan
  end

  depends_on "python"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7a/60/72d44d1a4ec99c0e8a47764a65850b08bd6e682e0e70ebab2b84632c3c56/argcomplete-1.8.2.tar.gz"
    sha256 "7a2ccde074eb6631232b2f91f8d8d5985d5bebf0e36b091113096e3a0385546b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
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
    url "https://files.pythonhosted.org/packages/96/6e/0723cccec195a37de6a428ad8879fe063b6debe5c855444e9285b27d253e/jmespath-0.9.2.tar.gz"
    sha256 "54c441e2e08b23f12d7fa7d8e6761768c47c969e6aed10eead57505ba760aee9"
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
    url "https://files.pythonhosted.org/packages/f7/63/cf85cfa172be9da3c64c6f1f54430411137b81b398bb0e13a04154e9a6df/msrest-0.6.1.tar.gz"
    sha256 "c087b91d68281a870e8cdff84f20dd55bbd6685daa76a307493e6e3a4343fc56"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "pyreadline" do
    url "https://files.pythonhosted.org/packages/bc/7c/d724ef1ec3ab2125f38a1d53285745445ec4a8f19b9bb0761b4064316679/pyreadline-2.1.zip"
    sha256 "4530592fc2e85b25b1a9f79664433da09237c1a270e4d78ea5aa3a2c7229e2d1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pywin32-ctypes" do
    url "https://files.pythonhosted.org/packages/7a/7d/0dbc4c99379452a819b0fb075a0ffbb98611df6b6d59f54db67367af5bc0/pywin32-ctypes-0.2.0.tar.gz"
    sha256 "24ffc3b341d457d48e8922352130cf2644024a4ff09762a2261fd34c36ee5942"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
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
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/e7/37/d8725833efba01d234aabda5a0c2ffb6c369dd3286bca265dfbbe7a51250/vsts-0.1.20.tar.gz"
    sha256 "1ece70729d616029f7fd1859524ee6b7d95ff07403af7bb4f963322ad28005f8"
  end

  resource "vsts-cli" do
    url "https://files.pythonhosted.org/packages/4f/6d/9289eef4bf97702b2538745cd5ff89ea6c5af7b2694acb34db94c0c9f340/vsts-cli-0.1.3.tar.gz"
    sha256 "49a02db989b1e311379c397bdd3572fd243b8d5068bbba5963ca56602a6f72e0"
  end

  resource "vsts-cli-admin" do
    url "https://files.pythonhosted.org/packages/30/d6/2edc4bac9abcd1227b2dbcf44648537e4f7e955d96c71495237c12daad54/vsts-cli-admin-0.1.3.tar.gz"
    sha256 "268b30b683c0f31e97544bfe3c771bf7be22435f474d09fe6d608048b240db0f"
  end

  resource "vsts-cli-admin-common" do
    url "https://files.pythonhosted.org/packages/da/06/a5293bf4db1e15d6f67710286228842b2e70c8047d967133fd4c83068d88/vsts-cli-admin-common-0.1.3.tar.gz"
    sha256 "71e06171d67b3e05facb69db34706f577616856e32c58be9923ca79c9e95b99b"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/d7/1f/2ae468b5ffe4e80a5133d21a20e7b8841cf942023830fc1ba085d17d2a84/vsts-cli-build-0.1.3.tar.gz"
    sha256 "a094dbd192aee14582e118ac817d34a4cd2e71c3d753399a25b1166c21ff8127"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/d9/ce/cd99b95346dd2b934875c42601b7f46e9f71527a46692ffe999d5930d65a/vsts-cli-build-common-0.1.3.tar.gz"
    sha256 "259387b5b9e7192d6a88ebd7b7c6f4352b49297447ff1125ed9c22f305fe8738"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/8e/c7/bf7671eae3b63fe78db9b4c097333f00a16ee348d1d187fbcd20699dac4f/vsts-cli-code-0.1.3.tar.gz"
    sha256 "1c3f011e3e9070734f1546733fee675ced3ace18650a3dd0063e67990ede68de"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/6d/69/53f770bf8745176fca48c128b50830bf40e8db4dad80906d1fdf9ef0aa4a/vsts-cli-code-common-0.1.3.tar.gz"
    sha256 "60bc55edaa1b6acde72e17f346224e9c0e2516278e9145f47fa8928b13752bb5"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/af/a2/103154e3e2550fa56041f1e6e74b089f623668cd4f683bb5e769599e7208/vsts-cli-common-0.1.3.tar.gz"
    sha256 "4c587ee2c588bb8af6c23606027b44bcf779d4d1f417ef8da02eef702b4bb661"
  end

  resource "vsts-cli-package" do
    url "https://files.pythonhosted.org/packages/8c/fd/8619ce3da27b51733d63180b418aa0b30d5a0125c4b7e340454b5ab17789/vsts-cli-package-0.1.3.tar.gz"
    sha256 "9cb535d2d96f8ee94491215537c5879725e6072f9adfacd8bf8f6e470a967036"
  end

  resource "vsts-cli-package-common" do
    url "https://files.pythonhosted.org/packages/8b/9f/807f79645bf21cece4528e57c254169ef3a86944f821d081fe491309fb61/vsts-cli-package-common-0.1.3.tar.gz"
    sha256 "4e1cc4bb2fd62c544e7645073b58658ad43342c8d66b0147960757e68d7fbce7"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/da/bf/0722942d3b73f3512fa1db38867bca1dead31b1894c97a07a9813ab2d955/vsts-cli-team-0.1.3.tar.gz"
    sha256 "fa595e528074e0ee19cefb72abb5146d191bc2006fdf250d827c8037e7be75db"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/62/8c/e1f83193fa376bee26c6542d46e6f65b1c79deb3f66fbc2d0275f7fd1d61/vsts-cli-team-common-0.1.3.tar.gz"
    sha256 "c3efa34b79b6ba008e840789e0a746408009324a7f917ca853a0245612db468b"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/8c/0f/bf0c3a0df9e365d5a26544bbbc460673fd15ec4fc9060849f7f58cb107c1/vsts-cli-work-0.1.3.tar.gz"
    sha256 "5d8381b6a9966a57651294dd50ef26888da57e717707a9447e196e9efd85c98c"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/f1/48/32b6c9c66f5df5d0109d8239dffe3976aa8c34b3877723bc58717045e248/vsts-cli-work-common-0.1.3.tar.gz"
    sha256 "65d309336e994d2824f732e1c32ae044ff8670f1fda5eb947fa42e2c79254b69"
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
