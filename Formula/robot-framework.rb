class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/c6/37/fc94979077241a09f31f347cbae401c9f62705eadd441a392285537e603c/robotframework-6.1.1.zip"
  sha256 "3fa18f2596a4df2418c4b59abf43248327c15ed38ad8665f6a9a9c75c95d7789"
  license "Apache-2.0"
  revision 1
  head "https://github.com/robotframework/robotframework.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "22b63370c83fa87afcf1ba718f48b180de43632cb016e99b34f716731578eb3f"
    sha256 cellar: :any,                 arm64_monterey: "60c752265849845f46d345f9b1efe2030b37fc39d779689fc85511b4684384f0"
    sha256 cellar: :any,                 arm64_big_sur:  "c07432e5904b7394d780e4c19bee6bafb7b8fbff9f4f4fe550f4a87799d18941"
    sha256 cellar: :any,                 ventura:        "baf14f1cee59efd811ae680f250a31b78d4bcc3c29325a4b86ee660c37eeeedb"
    sha256 cellar: :any,                 monterey:       "6c221301ddd07a39e764f256829a9f13425b8300a8e42709520cb5a76f9e0c50"
    sha256 cellar: :any,                 big_sur:        "bdc3cb1e93411c13cefd58c9c339447c68f7eaaca28df2a4f136d7d0e4401fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4085b0231639e6d83e6b32f1bbaaaad0f047853dc41f45788da896fedd6231bd"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/55/09/5d2079ecab0ca483e527a1707a483562bdc17abf829d3e73f0c1a73b61c7/exceptiongroup-1.1.2.tar.gz"
    sha256 "12c3e887d6485d16943a309616de20ae5582633e0a2eda17f4e10fd61c1e8af5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/dd/91/741e1626e89fdc3664169e16300c59eefa4b23540cc6d6c70450f885098f/outcome-1.2.0.tar.gz"
    sha256 "6f82bd3de45da303cf1f771ecafa1633750a358436a8bb60e06a1ceb745d2672"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/fb/20/a41b8c6694491c3cba5cb22f20a18015df1ed03fed78decafd60c254460f/robotframework-archivelibrary-0.4.2.tar.gz"
    sha256 "c2ae4d8b16aa79686cbc583e504d17c05852a41560a05d34811d815a9e1d5e79"
  end

  resource "robotframework-pythonlibcore" do
    url "https://files.pythonhosted.org/packages/11/95/1f2cb678b7dc17f7eef1fe7ac42f55ba8e16be2cb897d04ae744c765977a/robotframework-pythonlibcore-4.2.0.tar.gz"
    sha256 "f46d8a4b21ffa15f907148173a340bff70fdbfdbd160979b8f90d686e40fb1ae"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/c4/7d/3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2/robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https://files.pythonhosted.org/packages/a8/6b/579ff9b2933351a727c9b46b571c6f6cdde27c833dc41109f7cfca3b3468/robotframework-seleniumlibrary-6.1.0.tar.gz"
    sha256 "64686f6aa98b1fd1c340715c0adf8c09b6b405564086fbe672de31498a26ff0e"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/23/e9/74f3345024645a1e874c53064787a324eaecfb0c594c189699474370a147/robotframework-sshlibrary-3.8.0.tar.gz"
    sha256 "aedf8a02bcb7344404cf8575d0ada25d6c7dc2fcb65de2113c4e07c63d2446c2"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/b6/50/277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73/scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/9b/21/dc6e78b967b62cb39748bfd1af10cc245c8bc81ad8568b1efe80e73fd8a7/selenium-4.11.2.tar.gz"
    sha256 "9f9a5ed586280a3594f7461eb1d9dab3eac9d91e28572f365e9b98d9d03e02b5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/04/b0/5ec370ef69832f3d6d79069af7097dcec0a8c68fa898822e49ad621c4af0/trio-0.22.2.tar.gz"
    sha256 "3887cf18c8bcc894433420305468388dac76932e9668afa1c49aa3806b6accb3"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/07/ee/fcc7708dd5c8667caf3579c45067821d8e03a560faef9d53d46af7d7c851/trio-websocket-0.10.3.tar.gz"
    sha256 "1a748604ad906a7dcab9a43c6eb5681e37de4793ba0847ef0bc9486933ed027b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
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
