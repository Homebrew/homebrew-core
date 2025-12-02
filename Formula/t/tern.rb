class Tern < Formula
  include Language::Python::Virtualenv

  desc "Software Bill of Materials (SBOM) tool"
  homepage "https://github.com/tern-tools/tern"
  url "https://files.pythonhosted.org/packages/f8/4b/123b2ca469126b45e61853acf028fe1d466f4fe1d5e7afd1d4972c151b4d/tern-2.12.1.tar.gz"
  sha256 "c8c22f162962107adb64caaf5f764044e59caa28b9566079e101181c6449a1c0"
  license "BSD-2-Clause"
  head "https://github.com/tern-tools/tern.git", branch: "main"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_tahoe:   "c2368960d81379b79e48e0df91ecc463fd25fd8f595a7b1a6867d956e2c93ac0"
    sha256 cellar: :any,                 arm64_sequoia: "23a415ed6ef4ee3ae695c1c1c51ef8f6f31815083517b20343fb8070e4019f6a"
    sha256 cellar: :any,                 arm64_sonoma:  "76e87f5103ee3445130482b61c9e7f97368f06153681c199d9615d342cca0f26"
    sha256 cellar: :any,                 sonoma:        "cff0113720890d17c290f91528e1ebeeb4aea2581f9742894ea394c996126466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96820b7459cdc1803158765a4b10c56725f859bd9066761b5c5e9141318353d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835d90b9f1cd8d3af14850620412b055c765bdbee93ef95ba6446aaa2d5ed99a"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  on_linux do
    depends_on "attr" # for `getfattr`
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "debian-inspector" do
    url "https://files.pythonhosted.org/packages/76/27/2bdbfe084be16806c35fcc91bac3236706d1d62751c39a293b2cab77ebcc/debian_inspector-31.0.0.tar.gz"
    sha256 "46094f953464b269bb09855eadeee3c92cb6b487a0bfa26eba537b52cc3d6b47"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/92/df/929ee0b5d2c8bd8d713c45e71b94ab57c7e11e322130724d54f469b2cd48/dockerfile-parse-2.0.1.tar.gz"
    sha256 "3184ccdc513221983e503ac00e1aa504a2aa8f84e5de673c46b0b6eee99ec7bc"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/9a/c8/dd58967d119baab745caec2f9d853297cec1989ec1d63f677d3880632b88/gitpython-3.1.45.tar.gz"
    sha256 "85b0ee964ceddf211c41b9f27a49086010a190fd8132a24e21f362a4b36a791c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/3a/f0/de0ac00a4484c0d87b71e3d9985518278d89797fa725e90abd3453bccb42/packageurl_python-0.17.5.tar.gz"
    sha256 "a7be3f3ba70d705f738ace9bf6124f31920245a49fa69d4b416da7037dd2de61"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      tern requires root privileges so you will need to run `sudo tern`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = if OS.mac?
      shell_output("#{bin}/tern report --image alpine:3.13.5 2>&1", 1)
    else
      shell_output("#{bin}/tern report --image alpine:3.13.5 2>&1")
    end
    assert_match "rootfs - Running command", output
    assert_path_exists testpath/"tern.log"

    assert_match version.to_s, shell_output("#{bin}/tern --version")
  end
end
