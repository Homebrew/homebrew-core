class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/76/a3/e3bc54a669fa3ec440ea9d8db64590e761343b02b6ae9fcfcdc05c28d9ea/urlwatch-2.29.tar.gz"
  sha256 "f317ca8b123b15af510ec9e08bf885d8a8b574f502253e5ded200d757366da98"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac7e7a28492d7f82469bfb6cf2346b9e43753401d2b6e82528030c778ed1a525"
    sha256 cellar: :any,                 arm64_sequoia: "45337d7f580a0da3ec1b4cfae1d2844079528d162aed71e9ee0eab016b4fd3b8"
    sha256 cellar: :any,                 arm64_sonoma:  "a6e139a22713727aa2f54a6af5cab8d4a1cd7e049ec0c7cbd2469525f386d160"
    sha256 cellar: :any,                 sonoma:        "6058c34cd4720970c366f85bd01719b449307d3d2c0461b0823f63a3773b44e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82eb24893c17ca9a5de3f6c7f32f556b0ae8ec117593393d858c52f4d5903bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95afa07f41181c9dfce9430b72164c549e4f07644be2f33449b964611566ca34"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "cryptography" => :no_linkage
  end

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney secretstorage]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/aa/ea/5b803a05d523733735f8581cc8a51306cbea1a65ee4a5067abd98a969c4b/minidb-2.0.8.tar.gz"
    sha256 "d985748753cc19c2bed83654b77dd0f2212cfa82de7b8fbc8fe5f6058c2c661c"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/24/36/7180e7f077c38108945dbbdf60fe04db681c3feb6e96419f8c6dc8723741/requests-2.34.1.tar.gz"
    sha256 "0fc5669f2b69704449fe1552360bd2a73a54512dfd03e65529157f1513322beb"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end
