class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https://shub.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/ff/1c/02b628a398b06d3f2c34c5e413d61f92300064da01bbf212fe056d9eea0d/shub-2.14.5.tar.gz"
  sha256 "241b31dc4c2a96aa0915cf40f0e8d371fe116cd8d785ce18c96ff5bc4c585a73"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scrapinghub/shub.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "856df624a43227a0bd5e6184318336309da4d7dc0c7b05f21a412720ff22e297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9c8782c210729ac2ba711fd7cf1e3da4149b6fb11a1a427afad830aa9776fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7540837707dd9821295ed4ccdc53dbe45e38ac8114d82aed20cee2af997d2fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "4b48416d5f31ed136802bd473c41e19773e0e4c24261dcac69054f417f6b3657"
    sha256 cellar: :any_skip_relocation, monterey:       "6982d40d8d5213f9207da8c3dc3576cc8b9af9dbd6b6fcdd12fb5244391127be"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4fd12ed6914d69cbe966d20e97f136064b287f126b1cdebfbc73cbb28c19c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322eff975092342eb1796830aa28fa129763699aaf83cdc6124b7756012ea552"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "scrapinghub" do
    url "https://files.pythonhosted.org/packages/a4/5e/83f599af82e467a804da77824e2301ff253c6251c31ac56d0f70bac9e9ce/scrapinghub-2.4.0.tar.gz"
    sha256 "58b90ba44ee01b80576ecce45645e19ca4e6f1176f4da26fcfcbb71bf26f6814"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}/shub schedule 2>&1", 2)
  end
end
