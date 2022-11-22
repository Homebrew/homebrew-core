class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/e1/1d/283de30cfc04c3601fc73eca4f1b2a5cb5a25a9fa715eb2bf9678ab45d0d/urlwatch-2.25.tar.gz"
  sha256 "6802297d3318286e7f3d36b9a4567a2fb09b0ae779d4b76811dd29a7281c1f8a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "105f9638217032e3ad264a21508fe156ffd35bdc9d2091fe11834c592bd7f10a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fbfdb6c48a3bed7061c23cdf5f8d6710e2a3814dcd5890f1aeb3dba67c30116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e206295fa468c8a011c24928e3dbd1369ff50846e91f3ca6fa6aa7f411e04a8f"
    sha256 cellar: :any_skip_relocation, ventura:        "7614b1a8b2590d8d6c8e4f09fb9f523b6ae52f578a2d433bcedf50065dd2f69a"
    sha256 cellar: :any_skip_relocation, monterey:       "3db41fa757762edc24eee9ba8249662719183814b2e86f8b1bf0716bf49da493"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffd5cbc070fcacf518fb26bcb9a2862739a6191caa2faf9d672f685772ac5907"
    sha256 cellar: :any_skip_relocation, catalina:       "b515b71a833c2457660b9e9ec9cb97222ea5fd4a06222e9a7ee9e5aba094743c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f428f3fce7b936efd608c8e54d82a25efe9d3de0bd7911ba9d4d1af0a660f8"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/7e/ec/97f2ce958b62961fddd7258e0ceede844953606ad09b672fa03b86c453d3/importlib_metadata-5.0.0.tar.gz"
    sha256 "da31db32b304314d044d3c12c79bd59e307889b287ad12ff387b3500835fc2ab"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/1c/35/c22960f14f5e17384296b2f09da259f8b5244fb3831eccec71cf948a49c6/keyring-23.11.0.tar.gz"
    sha256 "ad192263e2cdd5f12875dedc2da13534359a7e760e77f8d04b50968a821c2361"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/20/d4/915ac3b905cf33f3a0df5c92619fad66ae2e23cecd8f21dbfa76a9a27133/minidb-2.0.7.tar.gz"
    sha256 "339fd231e3b34daecd3160946e0141585666ac57583882a14c4c69e597accca1"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8d/d7/1bd1e0a5bc95a27a6f5c4ee8066ddfc5b69a9ec8d39ab11a41a804ec8f0d/zipp-3.10.0.tar.gz"
    sha256 "7a7262fd930bd3e36c50b9a64897aec3fafff3dfdeec9623ae22b40e93f99bb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end
