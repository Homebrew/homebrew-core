class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/3.2.4.tar.gz"
  sha256 "2bb8ec5ab660fdcdacde1063e364cd6e7650355bcbbe10fec3df0af427ae9165"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a80eb13e7db7d2f41dd6c635ef14583de830b34b2970a3ef4585d354d12b211e"
    sha256 cellar: :any, big_sur:       "b84a6b60efa6c46fa6e6127e03bb5aac57733c4c8e0e23e14f515e501f184c22"
    sha256 cellar: :any, catalina:      "c86ccd6e7bbff491c6f0b4390dc3b310c5a0ac79388dc26646f96f8f28667cfc"
    sha256 cellar: :any, mojave:        "3ad7230bdbe5030194ef667988bb7156facb54e676eda60eeeabef8c1dde40ac"
  end

  depends_on "libyaml"
  depends_on "python@3.9"
  depends_on "six"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/30/2e/b86ce168485b68d40c6a810838669deacf0abf41845c383659c2b613e69f/aiodns-2.0.0.tar.gz"
    sha256 "815fdef4607474295d68da46978a54481dd1e7be153c7d60f9e72773cd38d77d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/99/f5/90ede947a3ce2d6de1614799f5fea4e93c19b6520a59dc5d2f64123b032f/aiohttp-3.7.4.post0.tar.gz"
    sha256 "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/40/e0/ad1edd74311831ca71b32a5b83352b490d78d11a90a1cde04e1b6830e018/aiosqlite-0.17.0.tar.gz"
    sha256 "f0e6acc24bc4864149267ac82fb46dfb3be4455f99fe21df82609cc6e6baee51"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/55/52/5c209d0e9f1ad857573be96b285626d5e081d86dd50d7617ff0874685dd4/backoff-1.10.0.tar.gz"
    sha256 "b8fba021fac74055ac05eb7c7bfce4723aedde6cd0a504e5326bcb0bdd6d19a4"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "censys" do
    url "https://files.pythonhosted.org/packages/60/86/410d1303606eb297ae46ead5da506b4ed17500b6a92c24577f8a661bd0ce/censys-1.1.1.tar.gz"
    sha256 "d7d935ffe3309f8279d566113f2d958803154fd090ad07abe0d3458a396db9fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1c/74/e8b46156f37ca56d10d895d4e8595aa2b344cff3c1fb3629ec97a8656ccb/multidict-5.1.0.tar.gz"
    sha256 "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/7f/69/2acf801ff56af4cca6a2d0e17108770c42eeb5596919254c5acbcf23efaf/plotly-4.14.3.tar.gz"
    sha256 "7d8aaeed392e82fb8e0e48899f2d3d957b12327f9d38cdd5802bc574a8a39d91"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/25/5a/ed8cc3340b7e83a5e572b5d27387a968a7e52b1e3c269442076ca902b7ba/pycares-4.0.0.tar.gz"
    sha256 "d0154fc5753b088758fbec9bc137e1b24bb84fc0c6a09725c8bac25a342311cd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/be/23/aaaa9e595a2baf40697657f899ec9890b2a9fbb89cda1af211ac2238d136/pyee2-2.0.0.tar.gz"
    sha256 "112cad20596ccffef8fd4c227b74a3940a40672d6b710f75e507cc1b73844755"
  end

  resource "pyppeteer" do
    url "https://files.pythonhosted.org/packages/07/67/a7eca24bf7620e11ba8be87a8c8eee5f3be0b2416aa942526b30d0348800/pyppeteer-0.2.5.tar.gz"
    sha256 "c2974be1afa13b17f7ecd120d265d8b8cd324d536a231c3953ca872b68aba4af"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c8/87/ba5671b333f1016a306f2e762fe762fbc9c3696614f6db3ce6171641005f/shodan-1.25.0.tar.gz"
    sha256 "7e2bddbc1b60bf620042d0010f4b762a80b43111dbea9c041d72d4325e260c23"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772/texttable-1.6.3.tar.gz"
    sha256 "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/ca/721a7abe555012efaa4d6ee18a0048a4f27d84c6220bb6aa6eba049117d6/tqdm-4.61.0.tar.gz"
    sha256 "cd5791b5d7c3f2f1819efc81d36eb719a38e0906a7380365c556779f585ea042"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/44/6e/0cb292e4e6ee1382e2ede458f90c94b4f990b261f738403ac45cb8183bc2/uvloop-0.15.2.tar.gz"
    sha256 "2bb0624a8a70834e54dde8feed62ed63b50bad7a1265c40d6403a2ac447bce01"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e9/2b/cf738670bb96eb25cb2caf5294e38a9dc3891a6bcd8e3a51770dbc517c65/websockets-8.1.tar.gz"
    sha256 "5c65d2da8c6bce0fca2528f69f44b2f977e06954c8512a952222cea50dad430f"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/84/49/89b391cf924c52e8003d9b7de1b2214441fd50c3bbe4b2ae0d81f5820379/XlsxWriter-1.4.3.tar.gz"
    sha256 "641db6e7b4f4982fd407a3f372f45b878766098250d26963e95e50121168cbe2"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/97/e7/af7219a0fe240e8ef6bb555341a63c43045c21ab0392b4435e754b716fa1/yarl-1.6.3.tar.gz"
    sha256 "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10"
  end

  def install
    venv = virtualenv_create(libexec/"venv", "python3")
    venv.pip_install resources

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", PATH: "#{libexec}/venv/bin:$PATH")
  end

  test do
    (testpath/"proxies.yaml").write <<~EOS
      http:
      - ip:port
    EOS

    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1")
    assert_match "docs.brew.sh:", output
  end
end
