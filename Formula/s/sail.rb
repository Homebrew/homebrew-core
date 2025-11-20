class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/1c/64/2af3a1a9dfa005dc91a22535a29071e9255efeacf7e61dbefee920d01571/sailed_io-0.10.9.tar.gz"
  sha256 "cae38b97fada34a7681872661342c82b317d877eab882830c59610734eb53bdf"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "3ce4a9f241e10ccf52e2d1efffa1d7795d043ce22f1f84f283444fe2a220dd6a"
    sha256 cellar: :any,                 arm64_sequoia: "5a0508d9c5bcf27a98e49231ed97a6d61989872c778773c074c11a2eb196fab1"
    sha256 cellar: :any,                 arm64_sonoma:  "8c7be99b7e7d1d1ad98ec570cf6022c951447c4c133e81f8b7b8b86464fa8dfa"
    sha256 cellar: :any,                 sonoma:        "692b3f1dff9d29816a262b8b84afe165e566f28ba2b0c01b9ac77820b9a7b5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e1f9c2b44e8dbae252c14b7e7c5dc09600674295c08066a231a811a89e1f352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76183cba24d5b6143d5aef4a19154211f19429fada46db3f0ce77e23b8768d21"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  # `pyyaml` package is manually updated to support Python 3.14

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
    sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/e4/a6/d07afcfdef402900229bcca795f80506b207af13a838d4d99ad45abf530c/jsonpickle-4.1.1.tar.gz"
    sha256 "f86e18f13e2b96c1c1eede0b7b90095bbb61d99fedc14813c44dc2f361dbbae1"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cc/af/11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889/paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/db/ed/c92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739/tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sail", shell_parameter_format: :click)
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
  end
end
