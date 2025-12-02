class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/dd/1e/34d60a04f97291d8c3c316a4f61d22b0870100adc704e8bedfb4930c0401/trailscraper-0.9.1.tar.gz"
  sha256 "96278fcd08aba2c684cad5e73972149d3f756ef52f146532440793ddcbbf9230"
  license "Apache-2.0"
  revision 2
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8da913c5b8d0e449868e097ecb12c2f33d7dee6c0f026385c5a13faad6d30c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4910ab0b8fbc98ce496cd35e4a725771cf741ea1edc1e9824659bd6641536f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f159c66daf496cf9e137d8154891355a2ed8892c0d665d86c8c86226812edf28"
    sha256 cellar: :any_skip_relocation, tahoe:         "02c4cbd4cb133ae5d892cd7f0cb3274dde7af9773b5c218dc3e85bc3748aed3c"
    sha256 cellar: :any_skip_relocation, sequoia:       "7f5bf17e597c820e7c00df37b3e663754421a53c5359485b5a5860018109e45b"
    sha256 cellar: :any_skip_relocation, sonoma:        "41c66b04cdbd8eb317d87073d4c659df3bff97c0df5c804cdf09b3e7076b09ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c069a63cedf9c96bd0482566cc611c0b54b9eeb7aa96924cd4bf77360b07342d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944dd3d39133adc61186caefc9dda00ab262a95122760272e01ab8fd972f62c3"
  end

  depends_on "python@3.14"

  pypi_packages extra_packages: "setuptools"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/32/f7/b870fb8d2ca96a996db97c9d30d1eb087b341cec1004722e99672a79800d/boto3-1.37.9.tar.gz"
    sha256 "51b76da93d7c2a3dff6155ee4aa25455940e7ade08292d22aeeed08b9e0dbf0b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/34/79/4e072e614339727f79afef704e5993b5b4d2667c1671c757cc4deb954744/botocore-1.37.38.tar.gz"
    sha256 "c3ea386177171f2259b284db6afc971c959ec103fa2115911c4368bea7cbbc5d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/bd/3f/d3207a05f5b6a78c66d86631e60bfba5af163738a599a5b9aa2c2737a09e/dateparser-1.2.1.tar.gz"
    sha256 "7e4919aeb48481dbfc01ac9683c8e20bfe95bb715a38c1e9f6af889f4f30ccc3"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5f/57/df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8a/pytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c4/2b/5c9562795c2eb2b5f63536961754760c25bf0f34af93d36aa28dea2fb303/s3transfer-0.11.5.tar.gz"
    sha256 "8c8aad92784779ab8688a61aefff3e28e9ebdce43142808eaa3f0b0f402f68b7"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/8a/0b/d80dfa675bf592f636d1ea0b835eab4ec8df6e9415d8cfd766df54456123/toolz-1.0.0.tar.gz"
    sha256 "2c86e3d9a04798ac556793bced838816296a2f085017664e4995cb40a1047a02"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"trailscraper", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
