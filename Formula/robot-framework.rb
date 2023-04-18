class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/8e/08/018fa8662f17ae912debcb939f8279fc40c4cf0bf172fdd1875532997e41/robotframework-6.0.2.zip"
  sha256 "6a9c06deb220099990f190c6e4e772675f625e4d5d84640fca6f0ad46ff538d0"
  license "Apache-2.0"
  head "https://github.com/robotframework/robotframework.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "c2a04867942944d387e63bf49ac6799e6fa65f173727d874b96ecf80f0af9360"
    sha256 cellar: :any,                 arm64_monterey: "00f401f7d4b5c8ffe3022c2aff0f2445219f3a50d9b15e89d55d77528cf7edfa"
    sha256 cellar: :any,                 arm64_big_sur:  "d4a85b69cc8920efff619f6f9b4e29d00db44b227cd1d26d511a1b1203a3850f"
    sha256 cellar: :any,                 ventura:        "4ba65b1a4269808136392bad465897183e99aa8ac3e5671393bdfbdf6d69c95b"
    sha256 cellar: :any,                 monterey:       "d5d37b387bfce4c7beed2b0c2ea5dd9255af4ca5b4c79e8ab8020876a2cb90f2"
    sha256 cellar: :any,                 big_sur:        "fee302f69ce840658deaa42925818f429fa1059baf5cb5a377922fed5c51161c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238e66ff71dab2c70ded06cb70140518dd7d8e232d4b20abf47b795840f2cd69"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "six"

  resource "async_generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
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
    url "https://files.pythonhosted.org/packages/3b/6b/554c00e5e68cd573bda345322a4e895e22686e94c7fa51848cd0e0442a71/paramiko-3.0.0.tar.gz"
    sha256 "fedc9b1dd43bc1d45f67f1ceca10bc336605427a46dcdf8dec6bfea3edf57965"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/fb/20/a41b8c6694491c3cba5cb22f20a18015df1ed03fed78decafd60c254460f/robotframework-archivelibrary-0.4.2.tar.gz"
    sha256 "c2ae4d8b16aa79686cbc583e504d17c05852a41560a05d34811d815a9e1d5e79"
  end

  resource "robotframework-pythonlibcore" do
    url "https://files.pythonhosted.org/packages/73/a9/8e721a37b2ad24865700833244a09f6e499529e3377bb0c9e003f457799b/robotframework-pythonlibcore-4.1.0.tar.gz"
    sha256 "b677313e2015d28a8bb2bbeb1d98d46e8e850b213113523a7cc9a7ca85016187"
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
    url "https://files.pythonhosted.org/packages/b6/50/277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73/scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/2e/3d/492cf1a6823c48369328572c6bc63b7a957ba25c0009ee6bdb507cd9a6a4/selenium-4.8.0.tar.gz"
    sha256 "fee36724d6cf0b18c73781bb8ec7be4a35ab1e2564e64e64e64da75e50e052af"
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
    url "https://files.pythonhosted.org/packages/0b/b8/1b81d2149c3e2c25900d40b8e6c8d3ca502a3cc844b90c962b0854aaf3f3/trio-0.22.0.tar.gz"
    sha256 "ce68f1c5400a47b137c5a4de72c7c901bd4e7a24fbdebfe9b41de8c6c04eaacf"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/75/91/44a0a016025794ba9fef530a6fbe59987153e2cbea7e11fe2f3d8c618740/trio-websocket-0.9.2.tar.gz"
    sha256 "a3d34de8fac26023eee701ed1e7bf4da9a8326b61a62934ec9e53b64970fd8fe"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
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
