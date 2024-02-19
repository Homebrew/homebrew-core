class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/78/5e/1b4d58586c93b730555650f63dfe84824784460c3740e8aabd959b6507f6/sigstore-2.1.0.tar.gz"
  sha256 "68761c3078aca9bb97af8459602959ff47ce648bf722a8c2c868e45b46aad7e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2de61175f8bb75f4d2cf90c4e8e8e643a460c3735038b735b6e73a9f2dacf8fe"
    sha256 cellar: :any,                 arm64_ventura:  "9f021e27cc8cada53ace509f04277c9ba5284649da0b99c634c29a3b0726b439"
    sha256 cellar: :any,                 arm64_monterey: "bad41b1103d50399ff2b5917fb9f0e7cc28d1b84e9db2cc48d031b09cad7e9ce"
    sha256 cellar: :any,                 sonoma:         "3b9af299161eb218f3d3d95a27b12874f0e1b6a1fe2048ca0d5eea0228623b7c"
    sha256 cellar: :any,                 ventura:        "db4d21f14008b075dc2b351eddd21f40ca5045df578b6e7e04c768122e23c309"
    sha256 cellar: :any,                 monterey:       "665ef40c8c2b4211ce33fc0850f22aa2442d269f38284142a14adf68dc4a037b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f653d0d75ab859ae07a0ffa750e5d35831283bbeee5115f31433032e142dc75"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "betterproto" do
    url "https://files.pythonhosted.org/packages/45/43/4c44efd75f2ef48a16b458c2fe2cff7aa74bab8fcadf2653bb5110a87f97/betterproto-2.0.0b6.tar.gz"
    sha256 "720ae92697000f6fcf049c69267d957f0871654c8b0d7458906607685daee784"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/69/36/70c8b90a303244b4b1bcb82c718797d91171c8f8b073fa9165c6f24df4fe/email_validator-2.1.0.post1.tar.gz"
    sha256 "a4b0bd1cf55f073b924258d19321b1f3aa74b4b5a71a42c305575dba920e1a44"
  end

  resource "grpclib" do
    url "https://files.pythonhosted.org/packages/79/b9/55936e462a5925190d7427e880b3033601d1effd13809b483d13a926061a/grpclib-0.4.7.tar.gz"
    sha256 "2988ef57c02b22b7a2e8e961792c41ccf97efc2ace91ae7a5b0de03c363823c3"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/4f/24/f5bb9deb79f6a7b761c075d1f5929ef3fda66f82f0376c5131fc6026a4d4/id-1.3.0.tar.gz"
    sha256 "c5dbb6048a469466054f065e92dba9b202a57d718cf12a0f24a082d0df988e18"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/aa/3f/56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490/pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/b2/7d/8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79/pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/c5/c9/70c2e5dc78554bb10da4b34d933a49d44727aeea4eedd39daa1635f24cc2/securesystemslib-0.31.0.tar.gz"
    sha256 "c1594afbcd5db198ec90c487e1720154afb71743d9f4bccf3dfda84de650c478"
  end

  resource "sigstore-protobuf-specs" do
    url "https://files.pythonhosted.org/packages/89/b6/5aa2f04b16cc089487fa5d40c0d032c989b2ba6d6e4f417d559ad9f8b85f/sigstore_protobuf_specs-0.2.2.tar.gz"
    sha256 "c05c1e7478a80af0c7dea9cc2d11f047826e4c029573d564137f788e11377391"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/32/cd/42f7a67aa471e783c26a44079bd9265f5a95a7c77cf2ef4efcebc180ec6a/sigstore_rekor_types-0.0.11.tar.gz"
    sha256 "791a696eccd5d07c933cc11d46dea22983efedaf5f1068734263ce0f25695bba"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/de/38/952484915f31eb9cfcf0cf6e0e513c1319a9079075e4722f4f92bece65d6/tuf-3.1.0.tar.gz"
    sha256 "3a4e9abba9d03c221842f62a9a687d51cc2b4a26c43ee7deb1ffb5fa2fb49374"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    resource "homebrew-test-artifact" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v2.0.1/sigstore-2.0.1.tar.gz", using: :nounzip
      sha256 "78013eaa2207c054ac803b361f8722011766d243bcbfa50c6e48003df2e3ca2f"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v2.0.1/sigstore-2.0.1.tar.gz.sigstore"
      sha256 "0d19d7b7c30423f00b0f4a73ae4964e9c234d71d9b307192e612175444691b03"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v2.0.1"

    output = shell_output("#{bin}/sigstore verify github sigstore-2.0.1.tar.gz --cert-identity #{cert_identity}")
    assert_match "OK: sigstore-2.0.1.tar.gz", output
  end
end
