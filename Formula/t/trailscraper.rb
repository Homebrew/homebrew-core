class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/dd/1e/34d60a04f97291d8c3c316a4f61d22b0870100adc704e8bedfb4930c0401/trailscraper-0.9.1.tar.gz"
  sha256 "96278fcd08aba2c684cad5e73972149d3f756ef52f146532440793ddcbbf9230"
  license "Apache-2.0"
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7856f4ab33ac9b4787b6c56fc26e9ea9660e924e88481a1aa58ed608da4ace20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c603d651c4ae97df0d9dabede01640cb88aca9cea648b458ff8c35e499608c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a96687c220abe1b8a7429b242a64759b5098ccdc9a81f9552bdcf29cf939beea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8e538ac5c4622711aecd3e77bc67c8e1f00abff7f98c82c55202759878af86"
    sha256 cellar: :any_skip_relocation, ventura:       "84d535f84b97e5b6908037dbb8b3b5c61cd96ab35fa4b43feaa5fe3c3ac8a246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61346a612501f3764460b152f173b7aeab63320eaeb27db81d14fd75c73ba3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba61947f1c52939514cc495327bfbca9585dfde5804f8e91165a19301633e275"
  end

  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/32/f7/b870fb8d2ca96a996db97c9d30d1eb087b341cec1004722e99672a79800d/boto3-1.37.9.tar.gz"
    sha256 "51b76da93d7c2a3dff6155ee4aa25455940e7ade08292d22aeeed08b9e0dbf0b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/18/53/3593b438ab1f9b6837cc90a8582dfa71c71c639e9359a01fd4d110f0566e/botocore-1.37.13.tar.gz"
    sha256 "60dfb831c54eb466db9b91891a6c8a0c223626caa049969d5d42858ad1e7f8c7"
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
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/d2/7b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732/setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
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
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
