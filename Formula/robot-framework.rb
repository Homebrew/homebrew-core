class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "http://robotframework.org/"
  url "https://github.com/robotframework/robotframework/archive/v3.0.4.tar.gz"
  sha256 "1557c83f456ae90645f9c88f1e3366571cc3fe0843bea20330601b9d00c47ece"
  head "https://github.com/robotframework/robotframework.git"

  bottle do
    cellar :any
    sha256 "c3da5bd979215a6043160ac821d91a62bb278a8cc98bb42ebf14ae1aefb5d353" => :mojave
    sha256 "4ba23cd77588a92f77606f3d2682414036267a30ec0020d212cab0b78f66a584" => :high_sierra
    sha256 "bc307ba65c8df63d4e26ee888afb59aafdcf8c493a7337f17a12d96056b9d3b9" => :sierra
    sha256 "fe9630b653c9e4a74afb0d71f68dc6201356f4da81b89ea05acd3b4cb00f44e9" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python@2"
  depends_on :x11

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"
    sha256 "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/29/b6/bf5bd38d5764f6afaf17b0debef580aee9bfbd63ad77a0e215389691fdfb/robotframework-archivelibrary-0.4.0.tar.gz"
    sha256 "d18dd05a9d43decef1352a9a7601522639e4e6f02a084692b6392603c5f6c063"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/c4/7d/3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2/robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https://files.pythonhosted.org/packages/66/ac/eead7e76d9bd70da601442809268f984cd03f9cb708fed9e087fbc7c7412/robotframework-seleniumlibrary-3.1.1.tar.gz"
    sha256 "d29213ff38a22352cf983f36c581be76428d899e5e390890acafe13ac278824c"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/6e/6c/137995fe4bf8e4bd55f2712923d0acdb07eab6cdc2758d06e01b08345f77/robotframework-sshlibrary-2.1.3.tar.gz"
    sha256 "ab1daa49d38934ad57433500c1e177b4f3b3a16f5218a687a6061014343dabcb"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/d4/28/8124d32415bd3d67fabea52480395427576b582771283e89ce10a56d9e5b/selenium-3.11.0.tar.gz"
    sha256 "5841fb30c3965866220c34d16de8e3d091e2833fcac385160a63db0c3522a297"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"HelloWorld.txt").write <<~EOS
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOS

    (testpath/"HelloWorld.py").write <<~EOS
      def hello_world():
          print "HELLO WORLD!"
    EOS
    system bin/"pybot", testpath/"HelloWorld.txt"
  end
end
