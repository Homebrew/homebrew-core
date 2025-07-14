class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https://xml2rfc.tools.ietf.org/"
  url "https://files.pythonhosted.org/packages/94/2a/bbd76ef42f69d07f7d736c113f4bdd050c7a8e7068f0f397d85185912756/xml2rfc-3.29.0.tar.gz"
  sha256 "82a1806095ea9a83caa9ee6923bf50f7b7686325042e3e023e34984a54c822db"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ietf-tools/xml2rfc.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b58b51ba8053f789dbc61750af7c47eccae45ab496826aadf2ae34d683bb8fa"
    sha256 cellar: :any,                 arm64_sonoma:  "dfa4382a842b2c2a21d0b55576bc16660143b9015c8a34ed08bee36f6ab95233"
    sha256 cellar: :any,                 arm64_ventura: "0bd04beeef67919b35edd8ff7181bdc0cca36df3b3dfb74b28b987c1c5f22863"
    sha256 cellar: :any,                 sonoma:        "b353c80310438079c9b8b5a54648144c9613d50bf6a0f9430583e2d1d2c09b36"
    sha256 cellar: :any,                 ventura:       "1bbb1720605cc429ddf061800c42ce7966c014ac4b76d8ca1b5ab0d0ba29373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f16fef757aab60ab1647f3f5ca2080c548fb6b6251862d220cd59d3e84a13d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd0eb0f94e4dcfc8b51dd45dac3d833bf1d05879bd54588942cc6a3746a5eba"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxslt"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/73/f7/f14b46d4bcd21092d7d3ccef689615220d8a08fb25e564b65d20738e672e/certifi-2025.6.15.tar.gz"
    sha256 "d747aa5a8b9bbbb1bb8c22bb13e22bd1f18e9796defa16bab421f7f7a317323b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "google-i18n-address" do
    url "https://files.pythonhosted.org/packages/37/75/c4dadb4845c8c930b94c8ff9d2dfa9855c0a005366af539fee8095e30765/google_i18n_address-3.1.1-py2.py3-none-any.whl"
    sha256 "f66f4fd2b75d1cd371fc0a7678a1d656da4aa3b32932279e78dd6cae776fc23d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/76/57/c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92/pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xml2rfc --version")

    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rfc category="info" docName="draft-sample-input-00"
           ipr="trust200902" submissionType="IETF">
        <?v3xml2rfc silence="The document date .*? is more than 3 days away from today's date" ?>
        <front>
          <title abbrev="Abbreviated Title">Put Your Internet Draft Title</title>
          <author fullname="John Doe" initials="J." role="editor" surname="Doe">
            <organization abbrev="Company">Company</organization>
            <address>
              <postal>
                <street></street>
                <city>Springfield</city>
                <region>IL</region>
                <country>US</country>
              </postal>
              <email>jdoe@example.com</email>
            </address>
          </author>
          <date month="December" year="2010" day="10"/>
          <abstract>
            <t>Insert an abstract: MANDATORY. This template is for creating an
              Internet-Draft.  With some out of scope characters
              in Chinese, by Xing Xing, 这里是中文译本
            </t>
          </abstract>
        </front>
        <middle>
          <section title="Some unicode strings">
            <t>Text body needs to deal with &#8216;funny&#8217; characters</t>
            <t>Pure out of scope 这里是中文译本</t>
            <t>Some re-mapped characters are ¢ or ©</t>
            <t>More re-mapped characters are ˜ and € and &#0094;</t>
          </section>
        </middle>
      </rfc>
    XML

    system bin/"xml2rfc", "test.xml", "--text", "--out", "out.txt"

    output = (testpath/"out.txt").read
    assert_match "Put Your Internet Draft Title", output
    assert_match "J. Doe", output
    assert_match "Text body needs to deal with", output
    assert_match "这里是中文译本", output
  end
end
