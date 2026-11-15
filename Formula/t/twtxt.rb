class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/fc/4c/cff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756/twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"
  revision 12

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83eee3ff9eb8b2bb2cde3ccee7d436f2a1a50a03624dc4f56b2f09d2b9f4aa0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fae6b1b95360079fd88d10511b5bd24a8f028a516126fea48f08e5767bd8953c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fcf2030f54cc6e42f26ce7f853fab573b64e8c4347d309383befb01c5e1f0ad"
    sha256 cellar: :any,                 arm64_linux:       "8bbb5ed9abef0c541b34c987a7fc8b54c4ef306ac8c64ec8a848ce9205064b26"
    sha256 cellar: :any,                 x86_64_linux:      "73e61029bf91bdf9739118547f21d797dd5c07d4dd8d0f1ef3f5c16f916475db"
  end

  depends_on "python@3.15"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/84ddb5ba16c4eb2c69c71db76ae3c579fe546e511f7170c7e27eedbab7c1/multidict-7.1.0.tar.gz"
    sha256 "61a4e5d81b8d4e4ad61964b230129e7a2b914793d96289029078fc9009f074ec"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  # Drop setuptools dep: https://github.com/buckket/twtxt/pull/178
  patch do
    url "https://github.com/buckket/twtxt/commit/12bdd3670bff339fd27a7cd71c8ec64086b4ae5b.patch?full_index=1"
    sha256 "e206e7d18040d2b6c0d93ef2d7e4770c3e24448621bc6b5e0f206e193c6298ad"
    type :backport
    resolves "https://github.com/buckket/twtxt/pull/178"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"twtxt", shell_parameter_format: :click)
  end

  test do
    (testpath/"config").write <<~INI
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      brewtest = https://example.org/alice.txt
    INI
    assert_match "✓ You’ve unfollowed brewtest", shell_output("#{bin}/twtxt -c config unfollow brewtest")

    assert_match version.to_s, shell_output("#{bin}/twtxt --version")
  end
end
