class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/dd/23/ddf0fec2197cd62b9059ea5ab425feb7c72229d97c285a74c20ea9d1b542/vsts-cli-0.1.0b3.tar.gz"
  sha256 "1d76ef141602b1a4a90067e06f79a477d10b6c154b613513007a506b00929e8b"

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
    url "https://files.pythonhosted.org/packages/a9/67/b2b53b157abf5973f795d6859f892a1dc2ac4ab1a232f57b34547be558eb/keyring-12.2.0.tar.gz"
    sha256 "4a639773932525ff25225cace20e74580403715b3e00a8ea94a7b121dad1cfac"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/c1/1a/af6ee1af6e10e52f0c476cda0ef8ace279906a55672a595a606a6fa02447/knack-0.2.0.tar.gz"
    sha256 "9e66e77d0046fec1419d88a5a88e3b6c69948473bc080d9e0df5250b1012233c"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/4f/a8/4626b184183977e470e9d6d3604c01ecd2f3463789f064aa59a2190965c0/msrest-0.4.28.tar.gz"
    sha256 "65bdde2ea8aa3312eb4ce6142d5da65d455f561a7676eee678c1a6e00416f5a0"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/47/b9/66278631430fe688b2e6c84df16619f1d1e27c9c6ebca28371f7c6fbb346/oauthlib-2.0.7.tar.gz"
    sha256 "909665297635fa11fe9914c146d875f2ed41c8c2d78e21a529dd71c0ba756508"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/c5/39/4da7c2dbc4f023fba5fb2325febcadf0d0ce0efdc8bd12083a0f65d20653/python-dateutil-2.7.2.tar.gz"
    sha256 "9d8074be4c993fbe4947878ce593052f71dac82932a677d49194d8ce9778002e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
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
    url "https://files.pythonhosted.org/packages/04/02/f2ad99db32d1946ca20ffc9c862bd1807f24d2cef5e97e053d778d4e016a/vsts-0.1.0b2.tar.gz"
    sha256 "d0d3a4e99282c00c77fd1f63628ce1a9597ef46ebe7661dd7a50b95128969d11"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/e4/39/ed4d17dc99cb5b598e9b822afaf1bcb08fadd6f24251213a51b718ca1042/vsts-cli-build-0.1.0b3.tar.gz"
    sha256 "e81c237b0a6c0b698e6bec8a0ed08d3ad1e10ce626893cb935aefdd776bee963"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/44/44/c2776c4ac4546a5bff7bb3c75e79bbc052d0c0f90ab68cc1f40f99ea1acc/vsts-cli-build-common-0.1.0b3.tar.gz"
    sha256 "b5be56a76d1683ee956f6d32035487945fbe5614262611e493855fe5a7a331e1"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/03/2f/48d592bee13bf29632f1ff4709d85dd53442cd7f00d4757b7f73f62c1259/vsts-cli-code-0.1.0b3.tar.gz"
    sha256 "1cbb0b40f41d9ce96824e4cd4bd13e15925894478171098fcf7526dc65165a01"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/3d/58/f7dbb36526b5f5231ef9bd8d5dbb2329697fe1413f4bc6e40827e799156d/vsts-cli-code-common-0.1.0b3.tar.gz"
    sha256 "f7068c89506307fc1462c4049c661113f5718983afd74e4a96614675b0ee3ef4"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/61/5a/334d99c29888218cf08636335a0a8e52c4efabe0db1b1b0030d2c1d113b3/vsts-cli-common-0.1.0b3.tar.gz"
    sha256 "2c6be3c85e96f2c8a6eedf767048f0b8fbae48a07d80a43ed3ef1bad313928e0"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/65/3f/c68146367e42b87e751b7027a2c36601fe424757f718cfe50064aba4c701/vsts-cli-team-0.1.0b3.tar.gz"
    sha256 "d36c23c3d052b2efaa1ae2059e771f8cbd2e988275c51aac21deb50c91b4c2ad"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/6c/2c/9e7695f678ae14f5ae6cc2799280785254dd447382f902887bc048c3af3f/vsts-cli-team-common-0.1.0b3.tar.gz"
    sha256 "afe42c0daf84943004658e2e48206753f248b7d47b78c8ffa7ed81faa702586f"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/ae/d2/27eb61a9035f7ed6886a59058b94fc62bb500e6da0c0f2ffcd8cf32c4592/vsts-cli-work-0.1.0b3.tar.gz"
    sha256 "5cd87c84f1491c2f165db56b165cdc38df6ca23e11a3cfcf8f5079317d7b69df"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/00/fe/466bac890e12d6d65d611fa9ddde5336dd07eef7190b4d46aee9ac2366c8/vsts-cli-work-common-0.1.0b3.tar.gz"
    sha256 "810e655b6e6eb06a2474d098eea839ea29be1edb22e787caa22358e8d5420a0e"
  end

  def install
    virtualenv_create(libexec, "python3")
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
