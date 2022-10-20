class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f7826d592fb2cd0063944e9d57cedf0176da034315bbd7f08f1455919d9d3ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40fa599bccc3e6c3a6cdf57d46373921cff6198cd77e849c9ac9749d51d9353a"
    sha256 cellar: :any_skip_relocation, monterey:       "397b415f897596dff9d85c6b7a25ebd4b0d5e9c8b3a37d5a340c2049945b0ef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d6773e57ecb1cb40e3f5740d3caedf893ac750d1cc6e5d57fd83a1564e8aa96"
    sha256 cellar: :any_skip_relocation, catalina:       "ed4069e849c2690b19808ea3c8864a52a4798306c39dbc2ce3c511e93334848e"
    sha256 cellar: :any_skip_relocation, mojave:         "00e511f22fd4827fdcfd37313317d8bca3591801bfaf1a70efb6ca5a99ee7ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d71474b73d8f249e111f67e6288c7bdf2b74ebcae1150e01b8f7a60169c611"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f1/25/4773ca66ec580636c4e8ab473c9e5375a266746f3dbfe4f85235b9c67211/boto3-1.18.62.tar.gz"
    sha256 "364a0fd497147ff0e15327f653223b05e60a1afce002995e5b1106084355352e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/60/dc/d214623d85eb3c8dcb26a60ea15df43ac81747bcb26db5cc957affb4c517/botocore-1.21.62.tar.gz"
    sha256 "c92fee381c6f2771f7ec2bffaff2938b8a1c2a957560815a01ad77c975268fdd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end
