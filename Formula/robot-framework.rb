class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/82/4d/81586f077fd94ebbf66840b1187a6789843c9830a3025ec182df2439f29b/robotframework-4.1.1.zip"
  sha256 "663f84c177b2fa9b3b782939e31637a057a33f3a4b29067812f1259b7f4bad35"
  license "Apache-2.0"
  revision 1
  head "https://github.com/robotframework/robotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db08e0c311a8a0cf0114d15673cf8200896d4bbe53390584eb8781247cd33a0a"
    sha256 cellar: :any,                 arm64_big_sur:  "2b09165fd26df1e9890a24ab3822b487e9dfa631f3c59341f7877d2f82579212"
    sha256 cellar: :any,                 monterey:       "4304975c66df59312eec256b26b9883b0ba63f505ddb6c204ef5ee9c803c8e20"
    sha256 cellar: :any,                 big_sur:        "44130a4512c422c25d87a032b7e8c8b38dc452bae64897053e2c64423c845b5c"
    sha256 cellar: :any,                 catalina:       "429e30236bd464ec6c0dd34d603e54dd07d7682044d4a0a2e0c37fea56b7278d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20c8591991cc7981309a3321c6d4fbbe3b080b23926a444dfc3bbacb8a1594b5"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/3d/ca/0cd119e4ebf6944d48b7e9467c9bc254ea3188cb2cf9109e8e87ae906a99/robotframework-archivelibrary-0.4.1.tar.gz"
    sha256 "61cfb1d74717cb11862c87d8f44f5b5cc4a2862de42c441859df83fc33dd3dcf"
  end

  resource "robotframework-pythonlibcore" do
    url "https://files.pythonhosted.org/packages/ce/f1/1a5d360be3a69e0ba502171eadd0ae922dd509d200495615246161b5c38a/robotframework-pythonlibcore-3.0.0.tar.gz"
    sha256 "1bce3b8dfcb7519789ee3a89320f6402e126f6d0a02794184a1ab8cee0e46b5d"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/c4/7d/3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2/robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https://files.pythonhosted.org/packages/c4/75/fe0184ba697a585d80457b74b7bed1bb290501cd6f9883d149efb4a3d9f2/robotframework-seleniumlibrary-5.1.3.tar.gz"
    sha256 "f51a0068c6c0d8107ee1120874a3afbf2bbe751fd0782cb86a27a616d9ca30b6"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/07/18/983ea1dfbbaa299cce92aaf62a9e8d3ba40d02f5bd4a9c9d1f62aace6ec6/robotframework-sshlibrary-3.7.0.tar.gz"
    sha256 "55bd5a11bb1fe60a5a83446e6a3e1e81b13fc671e3b660aa55912a263c1f63aa"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/7f/3c/3bfda15f1387d44721f78d338c004ebca27b1015c275da4d3272654be152/scp-0.14.0.tar.gz"
    sha256 "ddbdb3ef8c068aa1fd37a5fa65a122a80673c9fd73fdc5668a4604f99ccf5943"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources

    # remove non-native binary
    (libexec/"lib/python3.9/site-packages/selenium/webdriver/firefox/x86/x_ignore_nofocus.so").unlink if OS.linux?
  end

  test do
    (testpath/"HelloWorld.robot").write <<~EOS
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOS

    (testpath/"HelloWorld.py").write <<~EOS
      def hello_world():
          print("HELLO WORLD!")
    EOS
    system bin/"robot", testpath/"HelloWorld.robot"
  end
end
