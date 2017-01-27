class RobotFramework < Formula
  desc "Open source test framework for acceptance testing"
  homepage "http://robotframework.org/"
  url "https://github.com/robotframework/robotframework/archive/3.0.1.tar.gz"
  sha256 "354f539ef4b9f94f7faab7395aa60ff65f166f0609eba175ec9eb75eff8dfd9b"
  head "https://github.com/robotframework/robotframework.git"

  depends_on :x11
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/d1/5a/ebd00d884f30baf208359a027eb7b38372d81d0c004724bb1aa71ae43b37/paramiko-2.1.1.tar.gz"
    sha256 "d51dada7ad0736c116f8bfe3263627925947e4a50e61436a83d58bfe7055b575"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pykerberos" do
    url "https://files.pythonhosted.org/packages/5c/05/55936bc02aead261bc8d2edd57ffbdfb3f814549c85d011ee14d4763ace5/pykerberos-1.1.13.tar.gz"
    sha256 "3d32021c66b52e8054e8819791b2cf4fa11cb0f40a7cdcea5d8d35dc816f42ee"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "requests-kerberos" do
    url "https://files.pythonhosted.org/packages/f4/ad/f102020a3cbe7e229cf2f8dd298f378fe1180c3539d8872c00b13d5a7f7a/requests-kerberos-0.11.0.tar.gz"
    sha256 "ae734f71f46a7b205a74fb90e160c7ba4cc4e0dff2d4f3129cf74806b51b94ba"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/49/04/4ae79825aede567f27652663dfa441b1bf5b918c8e6e17d0c327ce10962c/robotframework-archivelibrary-0.3.2.tar.gz"
    sha256 "a9b2db827209f53fac77cb5f98b04e655e0933dd607d63da37765e44ebb374f2"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/0c/42/20c235e604bf736bc970c1275a78c4ea28c6453a0934002f95df9c49dad0/selenium-3.0.2.tar.gz"
    sha256 "85daad4d09be86bddd4f45579986ac316c1909c3b4653ed471ea4519eb413c8f"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/0a/d4/5bd64ce78d66e1a4d69457a12c90887cd468dc4de94709e35d12abe3c2ed/robotframework-selenium2library-1.8.0.tar.gz"
    sha256 "2cb983b3237a6f63842c2c800f35c77a76db88623751054644c50f7a3698c0f9"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/6e/6c/137995fe4bf8e4bd55f2712923d0acdb07eab6cdc2758d06e01b08345f77/robotframework-sshlibrary-2.1.3.tar.gz"
    sha256 "ab1daa49d38934ad57433500c1e177b4f3b3a16f5218a687a6061014343dabcb"
  end

  def install
    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
