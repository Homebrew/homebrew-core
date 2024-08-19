class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/bc/9b/f425ff02c84a16e434526d3ffe7abfc50589f46a5efe9b02cfd09bec698e/trailscraper-0.8.1.tar.gz"
  sha256 "fe0f7970554a7100be6a4dc6ecce0ce0f4a5a3337a689e7035df7ac3c37ec21a"
  license "Apache-2.0"
  revision 2
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "030fcc52b470369c9add987bab8e9de709af9404538cd8ef19418f492f28d188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d95e86577d6e154ed190f02e7e2caaea98f6a247536e17d51ba5e331cc26d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b4ba60b4717e947005bb3aed439fe48a0d031e930a3a6dc65ee7bee45b99f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c7821bbdbdc91998416d4eb31c3f65435088ae00d3154e27870a89cbd4c313"
    sha256 cellar: :any_skip_relocation, ventura:        "f36a48802e6a97654b7275d7dfbef2994fe04275099d8022165fd9c1994efd1a"
    sha256 cellar: :any_skip_relocation, monterey:       "612aa90487cc9c59dfa6b161e8f59406ab6381ac38894e8d2cb7d4e785809ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f39761ef6754b4d70de5632f9fea388466323d8b38d448987c236d943e00de6"
  end

  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/95/60/88c7932476b438fc4702daa0dc6f5663c8c1451898d3d7daa0f934468086/boto3-1.26.54.tar.gz"
    sha256 "4e876ba5d64928cde0c416dd844f04f22d6b73d14002bbc3ca55591f80f49927"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3d/f6/d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3/botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/bb/2d/2f5dc79f80623f0f7ec4ee5291512caffda18f3ea070cb2775cc7839733f/dateparser-1.1.6.tar.gz"
    sha256 "e703db1815270c020552f4b3e3a981937b48b2cbcfcef5347071b74788dd9214"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  # setuptools explicitly added due to https://github.com/flosell/trailscraper/issues/602
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"trailscraper", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
