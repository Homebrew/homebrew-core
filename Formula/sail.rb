class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/0e/d8/6cd8f95e1ad7abc50ce2e3cb4f21039cb56ffd68eb9cd4619defebd030f6/sailed.io-0.10.4.tar.gz"
  sha256 "3c2b29beb1a1cacc1865cb7a5f0bf4cdd66a53a6aea485d10c5a5cf58e23f326"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "708c722380578ae5d37a4e1577e5bfc4d90af019c400359439c45b380395ce0b"
    sha256 cellar: :any,                 arm64_big_sur:  "0b9d6b42a5b22da74f26b40765b8c793c633b1575aee2cf11e3791fee0e73c2d"
    sha256 cellar: :any,                 monterey:       "1ac3f39814d0db7adb279446e2827ec271eda888d19274ea3ef051b40b1a972c"
    sha256 cellar: :any,                 big_sur:        "e20a3a7e90d9afbc267cc4f8a7992c644c5b54f266b1dc169b3831165e040e43"
    sha256 cellar: :any,                 catalina:       "a7a9bbd770e7ca9264495f7335e1ad628554d320c3a2ae63ed237479a4372d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c955dc68003d18cc2d3890e13b9953d82fd60f4d34563771d997ac70a206ede"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/32/61/9a26b8f3dcdb5cb17daff57c9a85be6d5963d50488f45319d64a413da762/fabric-2.6.0.tar.gz"
    sha256 "47f184b070272796fd2f9f0436799e18f2ccba4ee8ee587796fca192acd46cd2"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/37/b3/0b88358ee07789688d17ec7074a656da68ced50a122183187be12928b535/invoke-1.6.0.tar.gz"
    sha256 "374d1e2ecf78981da94bfaf95366216aaec27c2d6a7b7d5818d92da55aa258d3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/35/0e/fe3ce0869add0213a1b45eef746cafb79ca45255a60ec918630c159e3490/jsonpickle-2.1.0.tar.gz"
    sha256 "84684cfc5338a534173c8dd69809e40f2865d0be1f8a2b7af8465e5b968dcfa9"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/ea/01/f4c41238b4e4cae41502598c79a62785bdfe9fb5bb54728775805bd0b5d8/paramiko-2.9.2.tar.gz"
    sha256 "944a9e5dbdd413ab6c7951ea46b0ab40713235a9c4c5ca81cfe45c6f14fa677b"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/df/16/e9d6bcf1aed52a55bc1696324ab22586716053b3e97b85266e0f3ad36bae/pathlib2-2.3.6.tar.gz"
    sha256 "7d8bcb5555003cdf4a8d2872c538faa3a0f5d20630cb360e518ca3b981795e5f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/71/19/d65d4c39aa12a5630a8aa02ead8324cfaae3217146b19dd25d88d763bbdf/prettytable-3.0.0.tar.gz"
    sha256 "69fe75d78ac8651e16dd61265b9e19626df5d630ae294fc31687aa6037b97a58"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/6c/aa/ddf3d8f064887d5b4ae2c0ba7c688baa6cb48717db001abd340b72350069/tldextract-3.1.2.tar.gz"
    sha256 "d2034c3558651f7d8fdadea83fb681050b2d662dc67a00d950326dc902029444"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    xy = Language::Python.major_minor_version "#{libexec}/bin/python"
    unittest = "#{libexec}/bin/python -m unittest discover "\
               "#{libexec}/lib/python#{xy}/site-packages/sail/tests 2>&1"

    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
    assert_match("OK", shell_output(unittest))
  end
end
