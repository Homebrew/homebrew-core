class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://files.pythonhosted.org/packages/b7/1a/a7884359429d801cd63c2c5512ad0a337a509994b0e42d9696d4778d71f6/twine-4.0.2.tar.gz"
  sha256 "9e102ef5fdd5a20661eb88fad46338806c3bd32cf1db729603fe3697b1bc83c8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/pypa/twine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ab87f0e613be2799060df60c38c97013e1ab3bc5eb6ee35d84a220929e0ef45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551f69fb16673a955db0d031964654479ad80f444e797390a85254a6228b19d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0847b37f58d6dd98f8b7eebe5f522f9c1218e0fec20ac370fbae0d88f71382ce"
    sha256 cellar: :any_skip_relocation, ventura:        "730b3cee135d66bc53508fe1a894025f800d7027151d941caa985800d869384d"
    sha256 cellar: :any_skip_relocation, monterey:       "35836ad93ed8c87f58df51d4063060c4bbd422ce03f912e7fa82d0a8dc1c07cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "de9128469f08d263fcdf0fbfdcd1f065ef05ab8b8cee6a51c5ce3a2f8a8a0546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfcda669511c4450bc8fb373899cb7c058c1a7dd0bea2d0cdf6d7248ae0cdb1b"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/7e/e6/d5f220ca638f6a25557a611860482cb6e54b2d97f0332966b1b005742e1f/bleach-6.0.0.tar.gz"
    sha256 "1a1a85c1595e07d8db14c5f09f09e6433502c51c595970edc090551f0db99414"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b7/56/7daf104a9cb6af39c00127aee6904b01040dbb12cf1ceedd6a087c097055/more-itertools-10.0.0.tar.gz"
    sha256 "cd65437d7c4b615ab81c0640c0480bc29a550ea032891977681efd28344d51e1"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/22/ec/12a48255bb1f15e2bd16a75e9f537ea498c8884069de4655afe47d5ffe34/readme_renderer-40.0.tar.gz"
    sha256 "9f77b519d96d03d7d7dce44977ba543090a14397c4f60de5b6eb5b8048110aa4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "tests/fixtures/twine-1.5.0-py2.py3-none-any.whl"
  end

  test do
    wheel = "twine-1.5.0-py2.py3-none-any.whl"
    cmd = "#{bin}/twine upload -uuser -ppass #{pkgshare}/#{wheel} 2>&1"
    assert_match(/Uploading.*#{wheel}.*HTTPError: 403/m, shell_output(cmd, 1))
  end
end
