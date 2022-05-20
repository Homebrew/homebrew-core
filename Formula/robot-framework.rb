class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/b8/58/739caa540ba895d583309884dab7ee6cf6d357a80dd3ed56a171c2cc143b/robotframework-5.0.1.zip"
  sha256 "cf5dc59777ed9d8c3e1e91fb4403454890242867735681f22f4f22dbb2a20fc8"
  license "Apache-2.0"
  head "https://github.com/robotframework/robotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "843799f7b5613b48738f8271f0ebcd0b046e44ddc42dba388e3764b87a2ef80d"
    sha256 cellar: :any,                 arm64_big_sur:  "f7a068d847c98c07c29e59bff19f45a0868c42d9d41d8fe4662b84cccfae7cf4"
    sha256 cellar: :any,                 monterey:       "04b828569daabe872d92d074ebf0a1112ce03969320c2929812ff3be7632d187"
    sha256 cellar: :any,                 big_sur:        "5dbb11a9327cad3eef90431898e638a6db9d818e591cdedb5aaf98227371aa01"
    sha256 cellar: :any,                 catalina:       "5f88fec005ad0e8c5c640d82682a91c39e47ede3ab767a00fa55fd77f3e821ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083b8407930d619f6010f4ae179fe355a3a31fe0a62c427bf1916808b63dd98c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a1/9b/737c2306468a9fce2d630f12c2f29a2674d7bbe406819334c0883e929812/paramiko-2.10.4.tar.gz"
    sha256 "3d2e650b6812ce6d160abff701d6ef4434ec97934b13e95cf1ad3da70ffb5c58"
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
