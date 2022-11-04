class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/f2/2f/fb1a1448a034b9993b0c2aa725a9908bf748ba77fd24b872f0bf8b74ef66/robotframework-6.0.1.zip"
  sha256 "b2d9a82912dfd27aae7afaad64771c58f5d948ca9d64e3ae72b16721b5e022ea"
  license "Apache-2.0"
  head "https://github.com/robotframework/robotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d2655c781e28ad04d22d356a8a7c4a4a1b8af014d25cadd23b996c92386e8c1"
    sha256 cellar: :any,                 arm64_monterey: "64b1407f804879914cf921949c47796b624650ef17136b0be169aed5c9ec9fa1"
    sha256 cellar: :any,                 arm64_big_sur:  "244b599e5a7ac836b7525d3208591af66e68696d17e319bff330f1cafdd0a042"
    sha256 cellar: :any,                 monterey:       "1f2dbc4790e38995fb618482c69e7454971e95b798e5ad5fbb8a64246c55bef4"
    sha256 cellar: :any,                 big_sur:        "526c448084c052d5497b411a9c8e791dbe03a1b814d238e210633ae9356afcc4"
    sha256 cellar: :any,                 catalina:       "ae92d2b6754d0a4ebc15f2e865c4d49af1845693f0f7482e48582b1e5143897c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba850629b50dd0037d3cc6f48c9a92f4ebd8c21c4fac245b67e8e64852eafa9"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/13/dd/a9608b7aebe5d2dc0c98a4b2090a6b815628efa46cc1c046b89d8cd25f4c/cryptography-38.0.3.tar.gz"
    sha256 "bfbe6ee19615b07a98b1d2287d6a6073f734735b49ee45b11324d85efc4d5cbd"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1d/08/3b8d8f1b4ec212c17429c2f3ff55b7f2237a1ad0c954972e39c8f0ac394c/paramiko-2.11.0.tar.gz"
    sha256 "003e6bee7c034c21fbb051bf83dc0a9ee4106204dd3c53054c71452cc4ec3938"
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
    url "https://files.pythonhosted.org/packages/c4/75/fe0184ba697a585d80457b74b7bed1bb290501cd6f9883d149efb4a3d9f2/robotframework-seleniumlibrary-5.1.3.tar.gz"
    sha256 "f51a0068c6c0d8107ee1120874a3afbf2bbe751fd0782cb86a27a616d9ca30b6"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources

    # remove non-native binary
    (libexec/Language::Python.site_packages("python3.10")/"selenium/webdriver/firefox/x86/x_ignore_nofocus.so").unlink
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
