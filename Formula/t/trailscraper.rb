class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/43/82/74344dd629ac17dc4b3906eb07a53a731c3ccc80913abdbbe378c658498f/trailscraper-0.10.0.tar.gz"
  sha256 "805994a27ebd3ecd9353cd85b54139822e73980b1da93f63fa0e5d42c8b67ec1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "211ee48397a8f9eca38fec6af3c1d5e8335eebff704764ab9e22d0e6adff7a95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e9ecbe4420edc217523594a628800aea581afbd7c35db6d2253433346aaac04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5241d6c9aec195bc6288f1c3fe5a889a1a739c77548db59cec6a1734135ba9f"
    sha256 cellar: :any_skip_relocation, tahoe:         "33088e0ae994011cc9b5bc16bd6abc065381ffa58833fe0158f5494a9ff8206a"
    sha256 cellar: :any_skip_relocation, sequoia:       "9e25f573e5f95de355d48c96aabbc4c72833cc82ae8cc2137bc4bb7ecf093bee"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf40d4c9a115696fed23acaa1b86c8944f21b7fb57c888797963170af8702ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70af4fce0008f94a13dc225cab22db39e0f96d3a6fab0456845428b48bd93bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66611bec486644411b49e4e9a2e182e3777da0fc11283954cbde3081b57262a8"
  end

  depends_on "python@3.14"

  pypi_packages extra_packages: "setuptools"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/61/ce/d6fbf9cdda1b40023ef60507adc1de1d7ba0786dc73ddca59f4bed487e40/boto3-1.38.3.tar.gz"
    sha256 "655d51abcd68a40a33c52dbaa2ca73fc63c746b894e2ae22ed8ddc1912ddd93f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/cf/5f/d76870e4399fbfc12aa5c3bb36029edfc1a434392afc70a343c9d7d96e90/botocore-1.38.46.tar.gz"
    sha256 "8798e5a418c27cf93195b077153644aea44cb171fcd56edc1ecebaa1e49e226e"
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
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/fc/9e/73b14aed38ee1f62cd30ab93cd0072dec7fb01f3033d116875ae3e7b8b44/s3transfer-0.12.0.tar.gz"
    sha256 "8ac58bc1989a3fdb7c7f3ee0918a66b160d038a147c7b5db1500930a607e9a1c"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
