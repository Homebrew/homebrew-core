class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/14/a7/7f3f93ab1d8d9f58e8dce01ff5bbbdaf5f6ce679e5e13638df0cd2bdbe9a/sailed.io-0.10.8.tar.gz"
  sha256 "c31f7adbf97ea4c2827e35f9615a54fe9a013bd0b16a655ad29a926d9f86f014"
  license "GPL-3.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9ccbb15749b49ac5db928bb94bc6b8759b92dc7db63fe9b0dd5df2efb64c28e"
    sha256 cellar: :any,                 arm64_ventura:  "491edc0ba6c7775ffdf64d052aecc16cf8f6618871fb7f9d572b45ed1ed81fb4"
    sha256 cellar: :any,                 arm64_monterey: "622d688b68788fe6ccae410d5ee48addbb957d17afff5a0b3c92d7e3b356269b"
    sha256 cellar: :any,                 sonoma:         "89a852e2b134f66705088cf73a09a22055156622b087c56e413f1ccd45d15f60"
    sha256 cellar: :any,                 ventura:        "44d2fe7fa5078f0f176a6a54f8b008fa5aca862a7a504aed5ae5249bab543925"
    sha256 cellar: :any,                 monterey:       "d1bb8cd852cff3faaf6559235269e95c077eb8ef35c14951bd79b7b2bee95b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e18bb3a4402577a337268f395f3a23bf69a6ee5b55abdf9314155f158d5c970"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/ca/e9/0b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356/bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
    sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/69/7d/73d36db6955bde2ed495ce40ce02c9a2533b8c7b64fd42a38b1ee879ea18/filelock-3.15.1.tar.gz"
    sha256 "58a2549afdf9e02e10720eaa4d4470f56386d7a6f72edd7d0596337af8ed7ad8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/fa/2d/806d7ce5743131a6a137c49016ad80db3c3a757288b863795bb50eb99603/jsonpickle-3.2.1.tar.gz"
    sha256 "4b6d7640974199f7acf9035295365b5a1a71a91109effa15ba170fbb48cf871c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ba/7a/dc3ffc0e333d33e8ccb63a14adc40180c29d89490a25ebe9f9ef01605c51/tldextract-3.6.0.tar.gz"
    sha256 "a5d8b6583791daca268a7592ebcf764152fa49617983c49916ee9de99b366222"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  # Fix SyntaxWarning's on python 3.12: https://github.com/kovshenin/sail/pull/110
  patch do
    url "https://github.com/kovshenin/sail/commit/260c90982c1e0a91e74e56b0f3187719cc18d624.patch?full_index=1"
    sha256 "47ccabd9d5ba8215e2f18768bbbf23c3fd638adda2629afd135a6190404cc996"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    # Workaround build isolation: https://github.com/kovshenin/sail/pull/110
    cp "sail/__version__.py", "__version__.py"
    inreplace "setup.py", "import sail", "import __version__ as sail"
    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin/"sail", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
  end
end
