class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "http://robotframework.org/"
  url "https://github.com/robotframework/robotframework/archive/3.0.2.tar.gz"
  sha256 "122d8dd93d9fa40fbaa8122e792d1ccb2d07a029534b2373c213568c055cf962"
  revision 1

  head "https://github.com/robotframework/robotframework.git"

  bottle do
    cellar :any
    sha256 "e71467e7cace9167b8d62d0a544a7000d5dae1a2c08cb35f0f905d7aa533c1d8" => :sierra
    sha256 "44b0195686fde0a85b3debb232802ff039ff055d1c7b679ab407f6ff5e9dc249" => :el_capitan
    sha256 "cf683298b37aa318d2593c96e83e1f101d37657ab290a75a8e997e087dd47115" => :yosemite
  end

  depends_on :x11
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/ce/39/17e90c2efacc4060915f7d1f9b8d2a5b20e54e46233bdf3092e68193407d/asn1crypto-0.21.1.tar.gz"
    sha256 "4e6d7b22814d680114a439faafeccb9402a78095fb23bf0b25f9404c6938a017"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570/decorator-4.0.11.tar.gz"
    sha256 "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/64/79/5e8baeedb6baf1d5879efa8cd012f801efc232e56a068550ba00d7e82625/paramiko-2.1.2.tar.gz"
    sha256 "5fae49bed35e2e3d45c4f7b0db2d38b9ca626312d91119b3991d0ecf8125e310"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pykerberos" do
    url "https://files.pythonhosted.org/packages/bf/64/dd86215662d7df0f4f35632849e3576646fe29416deb7766ee00e09bdad3/pykerberos-1.1.14.tar.gz"
    sha256 "60f84e1b606d58cc457b186914c195072ebebf5d5a05e75c0136541808e06523"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "requests-kerberos" do
    url "https://files.pythonhosted.org/packages/f4/ad/f102020a3cbe7e229cf2f8dd298f378fe1180c3539d8872c00b13d5a7f7a/requests-kerberos-0.11.0.tar.gz"
    sha256 "ae734f71f46a7b205a74fb90e160c7ba4cc4e0dff2d4f3129cf74806b51b94ba"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/49/04/4ae79825aede567f27652663dfa441b1bf5b918c8e6e17d0c327ce10962c/robotframework-archivelibrary-0.3.2.tar.gz"
    sha256 "a9b2db827209f53fac77cb5f98b04e655e0933dd607d63da37765e44ebb374f2"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/0a/d4/5bd64ce78d66e1a4d69457a12c90887cd468dc4de94709e35d12abe3c2ed/robotframework-selenium2library-1.8.0.tar.gz"
    sha256 "2cb983b3237a6f63842c2c800f35c77a76db88623751054644c50f7a3698c0f9"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/6e/6c/137995fe4bf8e4bd55f2712923d0acdb07eab6cdc2758d06e01b08345f77/robotframework-sshlibrary-2.1.3.tar.gz"
    sha256 "ab1daa49d38934ad57433500c1e177b4f3b3a16f5218a687a6061014343dabcb"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/6e/b6/a0881686c3e2eb09d7e5ba79b197325a88d786317a4e742dc6a9f5029c7a/selenium-3.3.0.tar.gz"
    sha256 "43ec925d704928f7a34cb8615354a55a6666b952db2041112473f41e815fb6ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"HelloWorld.txt").write <<-EOF.undent
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOF

    (testpath/"HelloWorld.py").write <<-EOF.undent
      def hello_world():
          print "HELLO WORLD!"
    EOF
    system bin/"pybot", testpath/"HelloWorld.txt"
  end
end
