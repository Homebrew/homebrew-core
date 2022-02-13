class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://saltproject.io/"
  url "https://files.pythonhosted.org/packages/0f/35/e4e1f092eb1a22e807f9bcc5712701bf4d55f9ab41eb2cca55680817ef05/salt-3004.tar.gz"
  sha256 "3d53561bc86e014dca2ec3dc981079be04d55ea047890cabde25e5b10bfa5b13"
  license "Apache-2.0"
  revision 1
  head "https://github.com/saltstack/salt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3b9197394edfe8fb34ee9347dfa6956322c4b3ff06906e9338bcae49b2c7c6a"
    sha256 cellar: :any,                 arm64_big_sur:  "8305b4d8a25285d3790accc72bf32533d87be0078e8b94d7d6985bbc288b4eac"
    sha256 cellar: :any,                 monterey:       "90119f731b01f13b72b29b7183d8116e1f556ef7ff07dd00ce30aef3c4035f4a"
    sha256 cellar: :any,                 big_sur:        "fb43c3220747e15c2765cd2547dfb1e58fa1ce42bf75d3a41f7d843783414277"
    sha256 cellar: :any,                 catalina:       "0b7b479e06d49678e091dc8db52cee0c0029a1443183980353cf1d35e471b326"
    sha256 cellar: :any,                 mojave:         "0ef6d36c15f1b9ee2845e01a45be1e68860ea5d9e9a32e0b63e280ce1a5fe03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92261447bce65f316635fb213653073e5b2246a0aca79e56d1ad9fd3f36f8dc"
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
    depends_on "pcre"
  end

  # Homebrew installs optional dependencies: pycryptodome, pygit2
  #
  # Plase do not add PyObjC (pyobjc* resources) since it causes broken linkage
  # https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/b6/a0/707142df518a602a2e36f9aa4f6dcc2cc9981843ffb7ba1207f7a084819d/apache-libcloud-2.5.0.tar.gz"
    sha256 "8f133038710257d39f9092ccaea694e31f7f4fe02c11d7fcc2674bc60a9448b6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/0e/77/0f823e39f78d97706b11cefc4b95829a2ca237a3021a37a6b7ec361b2113/cheroot-8.5.2.tar.gz"
    sha256 "f137d03fd5155b1364bea557a7c98168665c239f6c8cedd8f80e81cdfac01567"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/c6/0d/f6acfd12f098b9f05b9146b79b5a3fad02f4047a7831b5f5c9ee3fe54d56/CherryPy-18.6.1.tar.gz"
    sha256 "f33e87286e7b3e309e04e7225d8e49382d9d7773e6092241d7f613893c563495"
  end

  resource "contextvars" do
    url "https://files.pythonhosted.org/packages/83/96/55b82d9f13763be9d672622e1b8106c85acb83edd7cc2fa5bc67cd9877e9/contextvars-2.4.tar.gz"
    sha256 "f38c908aaa59c14335eeea12abea5f443646216c4e29380d7bf34d2018e2c39e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ec/4d/e6553122c85ec7c4c3e702142cc0f5ed02e5cf1b4d7ecea86a07e45725a0/GitPython-3.1.12.tar.gz"
    sha256 "42dbefd8d9e2576c496ed0059f3103dcef7125b9ce16f9d5f9c834aed44a1dac"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "immutables" do
    url "https://files.pythonhosted.org/packages/d5/33/1187e0fcc0a521a72234b011e06cff99f8a204e1125ea791c190bd780de7/immutables-0.15.tar.gz"
    sha256 "3713ab1ebbb6946b7ce1387bb9d1d7f5e09c45add58c2a2ee65f963c171e746b"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/aa/b9/514816064db3028d7370f2ce02e8e8f5d9bc68f6f9a41b04d19176aba70e/importlib_metadata-4.6.4.tar.gz"
    sha256 "7b30a78db2922d78a6f47fb30683156a14f3c6aa5cc23f77cc8967e9ab2d002f"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/7b/de/28a640c17a80f5e0fab5c494679e2e66b36d7fd20622e27718bea8be34b8/jaraco.classes-3.2.1.tar.gz"
    sha256 "ed54b728af1937dc16b7236fbaf34ba561ba1ace572b03fffa5486ed363ecf34"
  end

  resource "jaraco.collections" do
    url "https://files.pythonhosted.org/packages/d9/f8/da1c43345aa1ce0a98391497719cfc80d9664727431554a6aab5328481eb/jaraco.collections-3.4.0.tar.gz"
    sha256 "344d14769d716e7496af879ac71b3c6ebdd46abc64bd9ec21d15248365aa3ac9"
  end

  resource "jaraco.functools" do
    url "https://files.pythonhosted.org/packages/a9/1e/44f6a5cffef147a3ffd37a748b8f4c2ded9b07ca20a15f17cd9874158f24/jaraco.functools-2.0.tar.gz"
    sha256 "35ba944f52b1a7beee8843a5aa6752d1d5b79893eeb7770ea98be6b637bf9345"
  end

  resource "jaraco.text" do
    url "https://files.pythonhosted.org/packages/53/d2/40ff557369eccee312b2d3ff4cb97373e8ffb25afb92294ff650a1e45795/jaraco.text-3.5.1.tar.gz"
    sha256 "ede4e9103443b62b3d1d193257dfb85aab7c69a6cef78a0887d64bb307a03bc3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "linode-python" do
    url "https://files.pythonhosted.org/packages/4b/74/e488eb310b266e679e9e5095563be08185f2923802fb87be8f5cad652b74/linode-python-1.1.1.tar.gz"
    sha256 "5078aae54a5f6f325ac8cd47c3baa2582546d51b7060a0f9f6ad851027817bc0"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/5c/db/2d2d88b924aa4674a080aae83b59ea19d593250bfe5ed789947c21736785/Mako-1.1.4.tar.gz"
    sha256 "17831f0b7087c313c0ffae2bcbbd3c1d5ba9eeac9c38f2eb7b50e8c99fe9d5ab"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a0/47/6ff6d07d84c67e3462c50fa33bf649cda859a8773b53dc73842e84455c05/more-itertools-8.2.0.tar.gz"
    sha256 "b1ddb932186d8a6ac451e1d95844b382f55e12686d51ca0c68b6f61f2ab7a507"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "portend" do
    url "https://files.pythonhosted.org/packages/04/98/997f8668b11292f13d3e69fc626232c497228306c764523c5a3a3b59c775/portend-2.6.tar.gz"
    sha256 "600dd54175e17e9347e5f3d4217aa8bcf4bf4fa5ffbc4df034e5ec1ba7cdaff5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/64/ab/f2b4059ddf59bffbdbb4bdb60a6729c6c1de5eea1ef186d5a633ae12db3b/pycryptodome-3.11.0.tar.gz"
    sha256 "428096bbf7a77e207f418dfd4d7c284df8ade81d2dc80f010e92753a3e406ad0"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f5/79/9d9206688385d1e7a5ff925e7aab1d685636256e34a409037aa7adbbe611/pycryptodomex-3.9.8.tar.gz"
    sha256 "48cc2cfc251f04a6142badeb666d1ff49ca6fdfc303fd72579f62b768aaa52b9"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/7e/8c/c162e50ad20c36b457aa97a9d96536fde316d90052fb03fc4ae22a7fe9ea/pygit2-1.9.0.tar.gz"
    sha256 "c5e8588acad5e32fa0595582571059e6b90ec7c487c58b4e53c2800dcbde44c8"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/a7/4e/a7078f08a42b2563169ef20bc74d136015f1f3d0dbfa229070cf8ed4b686/python-gnupg-0.4.4.tar.gz"
    sha256 "45daf020b370bda13a1429c859fcdff0b766c0576844211446f9266cae97fb0e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/af/9f/5b4942b3b028fb38cd66514472649025644d78ca0b29f7b79e9ff2acc048/pyzmq-21.0.2.tar.gz"
    sha256 "098c13c6198913c2a0690235fa74d2e49161755f66b663beaec89651554cc79c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/89/2f/8902ee436e7e24e059973f9d7cbc1a433df10c93239f59c1d8539a86a6a5/smmap-3.0.2.tar.gz"
    sha256 "b46d3fc69ba5f367df96d91f8271e8ad667a198d5a28e215a6c3d9acd133a911"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/9e/38/69361106501ab8ca3bede11cff867ce86545461de55e65c14034c57be596/tempora-4.1.1.tar.gz"
    sha256 "c54da0f05405f04eb67abbb1dff4448fd91428b58cb00f0f645ea36f6a927950"
  end

  resource "timelib" do
    url "https://files.pythonhosted.org/packages/05/5d/fb7fb8f50c85913ee3a2b10bf21c6f85b4195223ddbe36da064932a17e9b/timelib-0.2.5.zip"
    sha256 "6ac9f79b09b63bbc07db88525c1f62de1f6d50b0fd9937a0cb05e3d38ce0af45"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "vultr" do
    url "https://files.pythonhosted.org/packages/ea/87/abe6e282bb4797f37fba197f0bd61f8d05f4f0b1158931124837e5ea1cff/vultr-1.0.1.tar.gz"
    sha256 "3f38849d267808c02fb2b2d9d2e394cb0be5b2d5b422b34bda01c4544060de1b"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3a/9f/1d4b62cbe8d222539a84089eeab603d8e45ee1f897803a0ae0860400d6e7/zipp-3.5.0.tar.gz"
    sha256 "f5812b1e007e48cff63449a5e9f4e7ebea716b4111f9c4f9a645f91d579bf0c4"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"
    xy = Language::Python.major_minor_version Formula["python@3.10"].bin/"python3.10"

    inreplace buildpath/"requirements/static/pkg/py#{xy}/darwin.txt", /^pyobjc.*$/, ""
    inreplace buildpath/"requirements/darwin.txt", "-r pyobjc.txt", ""

    virtualenv_install_with_resources

    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats
    <<~EOS
      Sample configuration files have been placed in #{etc}/saltstack.
      Saltstack will not use these by default.

      Homebrew's installation does not include PyObjC.
    EOS
  end

  test do
    output = shell_output("#{bin}/salt --config-dir=#{testpath} --log-file=/dev/null --versions")
    assert_match "Salt: #{version}", output
    assert_match "Python: #{Formula["python@3.10"].version}", output
    assert_match "libgit2: #{Formula["libgit2"].version}", output
    assert_match "M2Crypto: Not Installed", output
  end
end
