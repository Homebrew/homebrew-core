class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/cb/f9/04ce4ff8d87649b828c07035acfcc72805b15720ed8565745f697c18601e/robotframework-5.0.zip"
  sha256 "bffecba8c43d4294936d921f0af4941079039edce88194769133719732c608bc"
  license "Apache-2.0"
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
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/d4/93/1a1eb7f214e6774099d56153db9e612f93cb8ffcdfd2eca243fcd5bb3a78/paramiko-2.10.3.tar.gz"
    sha256 "ddb1977853aef82804b35d72a0e597b244fa326c404c350bd00c5b01dbfee71a"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
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
    url "https://files.pythonhosted.org/packages/31/cd/b96f0250c1876042500d0fd1c979c5824d71ced2bb440d1fb1f081872963/robotframework-seleniumlibrary-6.0.0.tar.gz"
    sha256 "ef6d5f1b481513cb6e3d15d78b0dcbabc53aa0866d8d23844b899ac824a0ea82"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/23/e9/74f3345024645a1e874c53064787a324eaecfb0c594c189699474370a147/robotframework-sshlibrary-3.8.0.tar.gz"
    sha256 "aedf8a02bcb7344404cf8575d0ada25d6c7dc2fcb65de2113c4e07c63d2446c2"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/01/96/82028abe87441ae172ce9df2eeb46274130475bfeeb4dedeaddaf75b16a9/scp-0.14.4.tar.gz"
    sha256 "54699b92cb68ae34b5928c48a888eab9722a212502cba89aa795bd56597505bd"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  def install
    virtualenv_install_with_resources

    # remove non-native binary
    (libexec/Language::Python.site_packages("python3")/"selenium/webdriver/firefox/x86/x_ignore_nofocus.so").unlink
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
