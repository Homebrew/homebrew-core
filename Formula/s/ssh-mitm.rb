class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https://docs.ssh-mitm.at"
  url "https://files.pythonhosted.org/packages/f0/4e/c804d08c336bcff29fd665fdc3ff9d3698d529b1d75462b89bc53527862a/ssh_mitm-5.0.1.tar.gz"
  sha256 "221dafeed602c4cca7a3c7fb2eee55eb9725ea11d19a75fd13c9bc3a1cf274ed"
  license "GPL-3.0-only"
  head "https://github.com/ssh-mitm/ssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a55f5b4396464f2e0381ae81d6d8d979840c0cb44c2f7ccd1a497cb03098fc8f"
    sha256 cellar: :any,                 arm64_sonoma:  "a446014221ba0da416901d29855310739ce926dc307b0786780a8a6f79d0c758"
    sha256 cellar: :any,                 arm64_ventura: "4b8683db03fe15cc9ea0c26d3cd4a1f84c17653cc318538f58bdd60c9ef4bca2"
    sha256 cellar: :any,                 sonoma:        "2ac9ca03de245736c9aa765420d8d902287427b33a5f98c503d71afdaaac6d03"
    sha256 cellar: :any,                 ventura:       "d64f6ecb3406e0cdbab184d33372a4ff98cf995c09f436eff8b51c06b62ebe3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd732d8076ea43939e12aeada39406c0045639cb04d2865b4e711937cd152b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1837df8e3c1b90cd075c5e6b33757f004211048f4c188b9384d5ff523c2ba166"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appimage" do
    url "https://files.pythonhosted.org/packages/58/30/625bf3d9cbb7b8736ea053b725bf72e55415cbe5ce4bf4c8971537fb5720/appimage-1.0.0.tar.gz"
    sha256 "75933b9df5cd77dcdc8187fda3142dd84ea63ffc40712369ecc19652ea1ef3ac"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/56/8c/dd696962612e4cd83c40a9e6b3db77bfe65a830f4b9af44098708584686c/bcrypt-4.2.1.tar.gz"
    sha256 "6765386e3ab87f569b276988742039baab087b2cdb01e809d74e74503c2faafe"
  end

  resource "colored" do
    url "https://files.pythonhosted.org/packages/2f/98/4d4546307039955eec131cf9538732fb7a28d2db2090cd1d4e4a135829e1/colored-2.2.4.tar.gz"
    sha256 "595e1dd7f3b472ea5f12af21d2fec8a2ea2cf8f9d93e67180197330b26df9b61"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/0b/6a/1d85cc9f5eaf49a769c7128039074bbb8127aba70756f05dfcf4326e72a1/paramiko-3.4.1.tar.gz"
    sha256 "8b15302870af7f6652f2e038975c1d2973f06046cb5d7d65355668b3ecbece0c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/e3/c4/358cd13daa1d912ef795010897a483ab2f0b41c9ea1b35235a8b2f7d15a7/python_json_logger-3.2.1.tar.gz"
    sha256 "8eb0554ea17cb75b05d2848bc14fb02fbdbd9d6972120781b974380bfa162008"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "ssh-mitm",
                                         shell_parameter_format: :arg)
  end

  test do
    # supress CryptographyDeprecationWarning warning,
    # upstream bug report https://github.com/ssh-mitm/ssh-mitm/issues/177
    ENV["PYTHONWARNINGS"] = "ignore"

    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end
