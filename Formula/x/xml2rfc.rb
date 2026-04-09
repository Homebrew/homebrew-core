class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https://xml2rfc.tools.ietf.org/"
  url "https://files.pythonhosted.org/packages/80/2b/8d90886577883e9d4e4cc60a1d9587923c1b3dc2890a61bdd3176ebf2c53/xml2rfc-3.32.0.tar.gz"
  sha256 "506d6fb5ff0bc029991c0d7fa8e429863005e2892c1dfe49fcc3e69ee94b76c9"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ietf-tools/xml2rfc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55cdb01c8b462fd756fee662b03a95fedec2fe77631bc23f5df97485a601bde0"
    sha256 cellar: :any,                 arm64_sequoia: "5e2a9611b2070e0c844398b59008748250b9328db6e049174b3e8981d6719ee5"
    sha256 cellar: :any,                 arm64_sonoma:  "ac58814eea9349f3d6b991a5984a59678182b3c1d1ce3476905a336db7af1ab2"
    sha256 cellar: :any,                 sonoma:        "84cf48628be077685458af54dfbd87d39a636f2355767188b52cd1184dfba074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20db338ad51f89d4589e1fdd768cab0f24fff90c3bd4d2e5d81b09e29e5fefc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30d4752c6b53f8162ceffa49851d8df5d7448158c3bca5b0cdc0962a873a85f"
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
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
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
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
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
