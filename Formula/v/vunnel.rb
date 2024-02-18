class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https://github.com/anchore/vunnel"
  url "https://files.pythonhosted.org/packages/22/40/97c4e624c3d3344a844e860d59922899cdd32484e5bdb5afcac9ca4f4fbd/vunnel-0.18.4.tar.gz"
  sha256 "4cf48152f599497c5a6cf750a3d621448f3dddd9e212a60146bac02f38e8a7fc"
  license "Apache-2.0"
  head "https://github.com/anchore/vunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99ad0e496ebd63bd668b7e83385c799e57437d527e56394963d04d7992275317"
    sha256 cellar: :any,                 arm64_ventura:  "d097cceb13bb15364524ed554daf7510aae8cbb4df19e577f77fcba72f2e61cf"
    sha256 cellar: :any,                 arm64_monterey: "eca6e88008707898503cc94646a4f35c78c024f386050b9b236a419187541e9d"
    sha256 cellar: :any,                 sonoma:         "df98f046d929aefd63b36f478c6d4c5235fd8fb98c233af0b1a265e93c317213"
    sha256 cellar: :any,                 ventura:        "4a5af7f96512edc5d29c9570dc5b6b29d2c802d748e63246c94ce283a2c9e9da"
    sha256 cellar: :any,                 monterey:       "26443a2a17c4b4825d97f5c6661b195c7e25a9befeaf312822a2c4b152cb3ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6051d6a06a877d1c61e344ba5dc18c730888c049703b1c31ae47fdc1045fa30b"
  end

  depends_on "rust" => :build
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lxml"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-pluggy"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "ruff"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/1f/b0/e4e3850d43f5429f9e53404056d705117fbb8a4d9e755425e762a9f68317/colorlog-6.8.0.tar.gz"
    sha256 "fbb6fdf9d5685f2517f388fb29bb27d54e8654dd31f58bc2a3b217e967a95ca6"
  end

  resource "cvss" do
    url "https://files.pythonhosted.org/packages/79/16/d2b86a5506ad5fee720c6f281d8499d86277ae05fea4861b3788d51cf295/cvss-2.6.tar.gz"
    sha256 "1e8f0c7ac1c1d7f4fb6d901950aa216358809de25ee7c41bc138615a23936c80"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https://files.pythonhosted.org/packages/f4/44/aba2c40cf796121b35835ea8c00bc5d93f2f70730eca53b36b8bbbfaefe1/docformatter-1.7.5.tar.gz"
    sha256 "ffed3da0daffa2e77f80ccba4f0e50bfa2755e1c10e130102571c890a61b246e"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/d0/12/3116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1/ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/ee/eb/58c2ab27ee628ad801f56d4017fe62afab0293116f6d0b08f1d5bd46e06f/importlib_metadata-6.11.0.tar.gz"
    sha256 "1231cf92d825c9e03cfc4da076a16de6422c863558229ea0b22b675657463443"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "mashumaro" do
    url "https://files.pythonhosted.org/packages/60/0c/fa3920716be345acc665de9ab3d16b3e38e41434ae01a208344b894bec32/mashumaro-3.11.tar.gz"
    sha256 "b0b2443be4bdad29bb209d91fe4a2a918fbd7b63cccfeb457c7eeb567db02f5e"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/3d/27/6a821fc97a2b68705cba3158e5ddb300938500a8c2b19dc084f6d43587d4/orjson-3.9.12.tar.gz"
    sha256 "da908d23a3b3243632b523344403b128722a5f45e278a8343c2bb67538dff0e4"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/80/1f/9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3/pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "pytest-snapshot" do
    url "https://files.pythonhosted.org/packages/9b/7b/ab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34/pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/c8/56/5a8dcb01ef7b68904f2a3224343d4ab3674b5cc8f48f7cefb0701bc75ab8/SQLAlchemy-1.4.51.tar.gz"
    sha256 "e7908c2025eb18394e32d65dd02d2e37e17d733cdbe7d78231c2b6d7eb20cdb9"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/69/19/8e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678b/toposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "untokenize" do
    url "https://files.pythonhosted.org/packages/f7/46/e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32/untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "xsdata" do
    url "https://files.pythonhosted.org/packages/74/be/57b774ff97dc081eef7d4ba6eae00e558d0f19e477f33c047fa2720aac47/xsdata-24.1.tar.gz"
    sha256 "e36fc8b4624bbbaf2d34d0857c6d78ede99ec1d3240cc7dd50546177fbb52442"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/04/ef/1a95dc97a71b128a7c5fd531e42574b274629a4ad1354a694087e2305467/xxhash-3.4.1.tar.gz"
    sha256 "0379d6cf1ff987cd421609a264ce025e74f346e3e145dd106c0cc2e3ec3f99a9"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vunnel --version")

    assert_match "alpine", shell_output("#{bin}/vunnel list")
  end
end
