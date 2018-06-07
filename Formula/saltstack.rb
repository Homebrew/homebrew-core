class Saltstack < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  url "https://files.pythonhosted.org/packages/11/52/29a7b924e495f22764603aa095ab41b2c4a952a4b57ad5689dd863e575ff/salt-2018.3.0.tar.gz"
  sha256 "a0a45d22fdf6961542a419b7e09568a3118e2b019ffe7bab9dee5aeb55b56b31"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "5ac25cd67791a8613a605d47729a946f455edafc1c855696cf5bbf735c011ac4" => :high_sierra
    sha256 "773bbb93ab3277520782d9734f3e1f55da6f6d578977522667ce1aa8ee0c994a" => :sierra
    sha256 "00b60a61a7af6eb2b9e4cd2aab748fe65ad8103e61f84682fac542246a6ee043" => :el_capitan
  end

  depends_on "swig" => :build
  depends_on "python@2"
  depends_on "zeromq"
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto

  # Saltstack's Git filesystem backend depends on pygit2 which depends on libgit2
  # pygit2 must be the same version as libgit2 - mismatched versions are incompatible

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/18/6f/bc49d68bae9171b2897d8de073369984a5f085111526ace6301fc3c1567f/M2Crypto-0.29.0.tar.gz"
    sha256 "a0fea2c5ab913e42864d1ccbaee5878c23886368b606e923609fda4ce37d26c0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz"
    sha256 "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/8a/20/6eca772d1a5830336f84aca1d8198e5a3f4715cd1c7fc36d3cc7f7185091/msgpack-python-0.5.6.tar.gz"
    sha256 "378cc8a6d3545b532dfd149da715abae4fda2a3adb6d74e525d0d5e51f46909b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/3b/0d/c11844421c7c3b9cb84c5503185bbb5ba780144fd64f5adde572bcdcdd8a/pygit2-0.27.0.tar.gz"
    sha256 "6febce4aea72f12ed5a1e7529b91119f21d93cb2ccb3f834eea26af76cc9a4cb"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/9f/f6/85a33a25128a4a812c3482547e3d458eebdb19ee0b4699f9199cdb2ad731/pyzmq-17.0.0.tar.gz"
    sha256 "0145ae59139b41f65e047a3a9ed11bbc36e37d5e96c64382fcdff911c4d8c3f0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/e3/7b/e29ab3d51c8df66922fea216e2bddfcb6430fb29620e5165b16a216e0d3c/tornado-4.5.3.tar.gz"
    sha256 "6d14e47eab0e15799cf3cdcc86b0b98279da68522caace2bd7ce644287685f0a"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c/typing-3.6.4.tar.gz"
    sha256 "d400a9344254803a2368533e4533a4200d21eb7b6b729c173bc38201a74db3f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats; <<~EOS
    Sample configuration files have been placed in #{etc}/saltstack.
    Saltstack will not use these by default.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salt --version")
  end
end
