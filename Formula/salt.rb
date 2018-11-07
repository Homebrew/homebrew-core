class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/9b/84/48b46bad5fa13b47c10a71b4f58cf0f3a30fcb32b6a6599fca454b8c6256/salt-2018.3.2.tar.gz"
  sha256 "d86eeea2e5387f4a64bbf0a11d103bfc8aac1122e19d39cc0945d33efdc797bd"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "cc567c62a20dde9b87d57b922b6a5b9f46c000b11f36fe2bec0e746458d5f9bd" => :mojave
    sha256 "b034cbf7bff9d1170413314e8fc7bc019056cd6143b9310ae9b08c7be74ebf79" => :high_sierra
    sha256 "fb934f06a2a238f3077089a7ce9cc63a2f2c64e197ddd52e40e088a325db1027" => :sierra
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto
  depends_on "python@2"
  depends_on "zeromq"

  # Saltstack's Git filesystem backend depends on pygit2 which depends on libgit2
  # pygit2 must be the same version as libgit2 - mismatched versions are incompatible

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/41/50/7d85dc99b1c4f29eca83873d851ec29a8e484a66b31351e62e30be9db7d1/M2Crypto-0.30.1.tar.gz"
    sha256 "a1b2751cdadc6afac3df8a5799676b7b7c67a6ad144bb62d38563062e7cd3fc6"
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
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
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
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz"
    sha256 "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3"
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
    url "https://files.pythonhosted.org/packages/fe/48/f85a605b7337b5562dff902ba1a50d8f22d399e0b623d0c48363dc84fa81/pygit2-0.27.1.tar.gz"
    sha256 "1aa5ba1d59370bda158950ba4849bb6e59f13ac7e6fca5e392bfd873bd2c1cf9"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/9f/f6/85a33a25128a4a812c3482547e3d458eebdb19ee0b4699f9199cdb2ad731/pyzmq-17.0.0.tar.gz"
    sha256 "0145ae59139b41f65e047a3a9ed11bbc36e37d5e96c64382fcdff911c4d8c3f0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
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
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl"].opt_include}"

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
