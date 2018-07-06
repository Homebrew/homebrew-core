class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/91/16/735321002a6940e7b429ce9b5e3c57c734951063ce5b4bfa73ab590cc801/vsts-cli-0.1.1.tar.gz"
  sha256 "35bc769a60693fb7e219144fc76ce7603d8b67f8d2dc0efa32a03140f7ea1298"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "751a2691ecac04952bcc0e2f86ed96d913fcf40ce7dd12445043ce06a699be57" => :high_sierra
    sha256 "d0c820f6428b5d36a02fe892345fd8af6d78363197a46314e575b605da4245ba" => :sierra
    sha256 "2bd52e840eea6f65f494a7c539ca6ccf0d0ab47f84059ed3cc92b1c0e5aa8dac" => :el_capitan
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
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
    url "https://files.pythonhosted.org/packages/bf/f8/275eb20a232d8d9558abfb32a98abc074b4c31b07fa148b1db5ca73f5b54/keyring-10.5.1.tar.gz"
    sha256 "f10674bb6ecbf82e2b713627c48ad0e84178e1c9d3dc1f0373261a0765402fb2"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/87/9d/1ac7e61b373e94ae96c28fc8e80976c24ce2f5d11c5d22330eed0a874dc9/knack-0.3.3.tar.gz"
    sha256 "dd2d3c4756975d6bdbbc65a25c067245350eec81547dac93a5c96a80a9f949f0"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/9b/49/ed5c9ea20f83707f4f67fbc664082d6d9a356b44f5f64ec5a5c7e0fdb365/msrest-0.4.29.tar.gz"
    sha256 "ce0a558173b7c7bff87dc66e24331382c81a89367ea52c52bbb934de6064cb45"
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
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
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
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/13/f9/5e9bdc96169bb86ee9ab0c84142715438f9419ab86eccae954bb4c318424/vsts-0.1.6.tar.gz"
    sha256 "c3db90754865dc271965f54d423cdb8bd349d0cec37f2452fb95a5d065847b21"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/f2/e6/3e830f6b9e8df74142db6767a3e27cea1e8c28405dc1a0e5fd057c7f32e1/vsts-cli-build-0.1.1.tar.gz"
    sha256 "99d87f87615e5b753c1a032256f034038d2e98048989e981c2c9abfee490169b"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/a7/bf/037330636dd6af702248a463dfd41526cd8bb27def7d3b2b152fe0b4f69c/vsts-cli-build-common-0.1.1.tar.gz"
    sha256 "428e54cd37f980b56b095cc2934d825241f493f835a36a1b7450a74610d0f94e"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/ca/c2/679a7cf3de08e55a51ec4152f5a4772095508275426a6dcfc21a3f51ad86/vsts-cli-code-0.1.1.tar.gz"
    sha256 "aa0ab1e54b8562f4d4dedae357e8b2b8c518f7714d1d79231b3512e378fd201a"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/86/11/b1fde7607903d8d2129025389f682fdf7ca5124a102e751eb9fb338dfd93/vsts-cli-code-common-0.1.1.tar.gz"
    sha256 "74ad53848050cc9e6513beadf1c88d414e199d038ad6696266326b225c9ddbc9"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/f9/19/b12331a93240d3ee13fe5461cb07086c40c741c59e46a662f2b67abeaa81/vsts-cli-common-0.1.1.tar.gz"
    sha256 "da933dbf19a52b8a4b1fde850f36a21a11fafdb5070da7ff34aa7351ec310994"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/c8/14/40bdb2e6ca147563da8cb01870aaa5f9c0d59aff8a87505dc2bf8d1b6fa0/vsts-cli-team-0.1.1.tar.gz"
    sha256 "23f1d97801ee1d2c24cc08683491d9966d0ddb5bc5a474b423eaf2d4467a982d"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/60/d7/829b42cd78c16a9080924291fb5ccdbbf481b16a0ecca66d52675228ac49/vsts-cli-team-common-0.1.1.tar.gz"
    sha256 "49853e11855909f8b50b5185f0515b2198e69bdeefa1b12315d2e9c6b9d01a6b"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/27/83/ef97b45a36a6a3473f4a79985988a38107d8166349aead245008e130072f/vsts-cli-work-0.1.1.tar.gz"
    sha256 "ec40ff57e9136a99eaacae06c2bea7e95d40e45660b22764785bdffa69796167"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/f3/32/81140e5681aa9bbc685dfe023e8ec01255cd345a46bbe6649fb5a6ff1864/vsts-cli-work-common-0.1.1.tar.gz"
    sha256 "6d8788e78cbb47a0df8a7ea08f0de66c7b1d31081c3e00734da06719fa7f1ae3"
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
