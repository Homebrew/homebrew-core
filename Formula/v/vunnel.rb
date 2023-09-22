class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https://github.com/anchore/vunnel"
  url "https://files.pythonhosted.org/packages/ef/05/d3e4e81a74f498f310c9a8be5fba0effea671298f6961c904242bd2b3952/vunnel-0.16.0.tar.gz"
  sha256 "9d53086786b33e06bf6076f7cd22c7d7ef77cbef34fa2db92d18b14ce0f9fae5"
  license "Apache-2.0"
  head "https://github.com/anchore/vunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1bd9e927c7aafcf4a74c1516331951ba5d13bb2bf1ad79962554213d3f42faf3"
    sha256 cellar: :any,                 arm64_monterey: "124b44541b98b123da751c95d22152a0806fd73678449aa730a2a32db90534bb"
    sha256 cellar: :any,                 arm64_big_sur:  "0fb9b777dd7473f92c1812c318d7747d85ca5032473f1c8105f00e0ffd99515b"
    sha256 cellar: :any,                 ventura:        "7c5e20a29dd937982334d68ab1ec7ab0ed86c4a723a4b85bff7e5b240ebcf842"
    sha256 cellar: :any,                 monterey:       "4b41b7519f9e41a48831b812462c28af670bb0ccdbc595af2fdb66df46c75986"
    sha256 cellar: :any,                 big_sur:        "c92739b2e9b4f045e7b3a0b95c62cc43dc25bba65ae8f2ba769009bfc9dc9d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15de4efe68b3b1ebde6c5a1e996fc26b1ec4f45741d464cafcdb1738ced92309"
  end

  depends_on "rust" => :build
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # For `lxml` resource.
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "cvss" do
    url "https://files.pythonhosted.org/packages/79/16/d2b86a5506ad5fee720c6f281d8499d86277ae05fea4861b3788d51cf295/cvss-2.6.tar.gz"
    sha256 "1e8f0c7ac1c1d7f4fb6d901950aa216358809de25ee7c41bc138615a23936c80"
  end

  resource "dataclass-wizard" do
    url "https://files.pythonhosted.org/packages/cb/5b/00d70960d5277b8be8c5a79c986b6170285a07f162cf05ee33e87fd7f392/dataclass-wizard-0.22.2.tar.gz"
    sha256 "211f842e5e9a8ace50ba891ef428cd78c82579fb98024f80f3e630ca8d1946f6"
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
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/d0/12/3116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1/ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/d9/e8/3b73e455a5f5f16ed70b364b5dbaec5691e7ae1d3c1e6cf8945735ec05a0/orjson-3.9.7.tar.gz"
    sha256 "85e39198f78e2f7e054d296395f6c96f5e02892337746ef5b6a1bf3ed5910142"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339" do
    url "https://files.pythonhosted.org/packages/91/fb/2835a62f2de226796fce76411daec6b9831eaf6d2fd04994ac1de055dc13/rfc3339-6.2.tar.gz"
    sha256 "d53c3b5eefaef892b7240ba2a91fef012e86faa4d0a0ca782359c490e00ad4d0"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/27/7c/ab28273996e8e5b78ddaeddbc1df54033231ff325827b3149d51334ed852/SQLAlchemy-1.4.49.tar.gz"
    sha256 "06ff25cbae30c396c4b7737464f2a7fc37a67b7da409993b182b024cec80aed9"
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
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
  end

  resource "xsdata" do
    url "https://files.pythonhosted.org/packages/95/0a/0c02e977b5de947535dd974f785c5600287df2c9bc6e5a70f67c46e6370d/xsdata-23.8.tar.gz"
    sha256 "55f03d4c88236f047266affe550ba0dd19476adfce6a01f3e0aefac7c8078e56"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/07/5f/6951f7496b0a452f3e79e39d48e7166b3445d1e064691b7df99d1ee80196/xxhash-3.3.0.tar.gz"
    sha256 "c3f9e322b1ebeebd44e3d9d2d9b124e0c550c1ef41bd552afdcdd719516ee41a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vunnel --version")

    assert_match "recording workspace state", shell_output("#{bin}/vunnel run alpine 2>&1")
  end
end
