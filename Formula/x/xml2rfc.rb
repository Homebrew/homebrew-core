class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https://xml2rfc.tools.ietf.org/"
  url "https://files.pythonhosted.org/packages/aa/c2/3f2420a11cac97c5e3ee3e04cc752f9018cf7ef97490e925498397a98aa1/xml2rfc-3.34.0.tar.gz"
  sha256 "173ad5cd21f7a2fddb0dbc19649bc8f73716dff5465e4e4fcd5bb21d5208ccf1"
  license "BSD-3-Clause"
  head "https://github.com/ietf-tools/xml2rfc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c9f66628845e4b21e0bdce90c2dc088b5f8cdb7bc025a64ffb7e3efb6573304"
    sha256 cellar: :any, arm64_sequoia: "e2ec741af80a65c04d4bf558c3145c8f9ea354e1b84311e2883e3ac718e8dac8"
    sha256 cellar: :any, arm64_sonoma:  "e514b5816cfc950e187123bccbb694c0ff86bf89f0ec63cd10340b99c905345a"
    sha256 cellar: :any, sonoma:        "2c5952ec8c5271bb2eed7ccc2aa7814e85ee9f1d6362d2c1ef08be6777f63d0b"
    sha256 cellar: :any, arm64_linux:   "bcc48ccc5ac28fa868f3f40d6a14bc1d1150106cb0b9697df2098c130797197f"
    sha256 cellar: :any, x86_64_linux:  "bf02648e8496d227ebb7a77526280e19055995acbba124d71f1d8eec64a48e72"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxslt"
  end

  pypi_packages exclude_packages: "certifi"

  # Keep none-any.whl for `google-i18n-address`,
  # if not then there will be an ModuleNotFoundError: No module named 'i18naddress'

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "google-i18n-address" do
    url "https://files.pythonhosted.org/packages/37/75/c4dadb4845c8c930b94c8ff9d2dfa9855c0a005366af539fee8095e30765/google_i18n_address-3.1.1-py2.py3-none-any.whl"
    sha256 "f66f4fd2b75d1cd371fc0a7678a1d656da4aa3b32932279e78dd6cae776fc23d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/53/c3/b2afa612aa0373f3e6bb190e6de35f293b307d1537f109e3e25dbfcdf212/intervaltree-3.2.1.tar.gz"
    sha256 "f3f7e8baeb7dd75b9f7a6d33cf3ec10025984a8e66e3016d537e52130c73cfe2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/de/1d/061b9e7a48b85cfd69f33c33d2ef784a531c359399ad764243399673c8f5/pycountry-26.2.16.tar.gz"
    sha256 "5b6027d453fcd6060112b951dd010f01f168b51b4bf8a1f1fc8c95c8d94a0801"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
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
