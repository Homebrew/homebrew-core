class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/19/87/54c755a1eac7d3a4db088500a2db59ffa9b939d86632bcb51c74db01f5a1/sigstore-2.1.2.tar.gz"
  sha256 "94139c1efa0784135516d11b79c8b06d4ea61245624e69cda44494e87560b07c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "42ec7c67b4b852637d24830975ebe35a406d914c50b85e73a8f20375c90d231a"
    sha256 cellar: :any,                 arm64_ventura:  "85ec9fabcb1c9358e10c3c7e0baf5637a05564d3bd372455f12f759fa1c7c549"
    sha256 cellar: :any,                 arm64_monterey: "89b0364dfa23cf5a1afcc7ecfb787e80958dccd8f4b95de8825f35a954a7e581"
    sha256 cellar: :any,                 sonoma:         "6f56b6b8c227ee82cdab065b61e4459330ba3dffc54fa5cea690299de3bb2d15"
    sha256 cellar: :any,                 ventura:        "612f4e6a20859975cad96141cdf0e6715895ab6a061a0f66248c7c0524beb0c8"
    sha256 cellar: :any,                 monterey:       "1f22b65b275017179b6f95a7bf5f99157e9ae302447a28d220ef497de7766f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c418cfd6069409ac2812e97a5669613fe3caba9da95dc3f9077096aa7da89ba4"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
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
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/73/27/a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8f/pydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/0d/72/64550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85/pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/1f/fa/0a00c2dfa9dbf83e58b490e6ee0656b3aac929c9887e359881a3ecd4b971/tuf-3.1.1.tar.gz"
    sha256 "73b3c89a0acdfe90434bba3118c90c584ef1c56bc0c4565852e917408b774130"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    resource "homebrew-test-artifact" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v2.1.2/sigstore-2.1.2.tar.gz", using: :nounzip
      sha256 "94139c1efa0784135516d11b79c8b06d4ea61245624e69cda44494e87560b07c"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v2.1.2/sigstore-2.1.2.tar.gz.sigstore"
      sha256 "26743e1c9898ee7a24a64a442d512a073a2078a3ff57dabf2929bbcc0fbcf03a"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v2.1.2"

    output = shell_output("#{bin}/sigstore verify github sigstore-2.1.2.tar.gz --cert-identity #{cert_identity}")
    assert_match "OK: sigstore-2.1.2.tar.gz", output
  end
end
