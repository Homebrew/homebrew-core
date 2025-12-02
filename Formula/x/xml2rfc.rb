class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https://xml2rfc.tools.ietf.org/"
  url "https://files.pythonhosted.org/packages/e5/bf/958badb4a48c9a91abf1e4896f81a2164127f86b53b0b099fc024c849584/xml2rfc-3.31.0.tar.gz"
  sha256 "0a1d4ccc4425aed39b5f0f833a8eb1e0f9e8f1897d3441c3a15877dee36cf484"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ietf-tools/xml2rfc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f18d86e7b2fa60587d8a594ad20e68c1586e90f6dee6656d5b8346e7bf60e294"
    sha256 cellar: :any,                 arm64_sequoia: "6255a8f3ccf9370cff0210a9162692840e75138ab2b54ce08c7859d6f82fe246"
    sha256 cellar: :any,                 arm64_sonoma:  "42d30f845e9bf29c3a040d54a6955432c95a8876b32c17e5c4eb44853a1efeda"
    sha256 cellar: :any,                 sonoma:        "609bafb56b3582e07ca168090b34d56b0648947fc96169248e2688dae1e169c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a6b211f38fd0550e320901a7333e560af4f790999abd982c53a94b765c83d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b154aea07d192be381e69d8b50d8d763e4cd8a541f2e93708020dd0a1ced84"
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
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/76/57/c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92/pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
