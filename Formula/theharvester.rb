class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/4.0.2.tar.gz"
  sha256 "c6615b9adc406b7b0ece99dcc95200621b047c2612be1e2f6ee653ec38ee3a64"
  license "GPL-2.0-only"
  head "https://github.com/laramies/theHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5368097bec83ea8c65c46b56512a663395d9b9beee7f421f14a09599a0ce9a00"
    sha256 cellar: :any,                 arm64_big_sur:  "4f0d342c2cce67e5f8a586138bc7f89c905a2e02b94939d78449ec6a4433b887"
    sha256 cellar: :any,                 monterey:       "1e8b4cc721c8fcdb7c71b8b034e428754fd785abc0ced8f74185b0bc8ac04db1"
    sha256 cellar: :any,                 big_sur:        "239a40a9eff32ad2b981548a6d5959a468c1b6227e14842526ad4cb22f2cd8a6"
    sha256 cellar: :any,                 catalina:       "19d2b721342dd34859f3efa8124ad4f7cce06a0b25dbb668eaf8ee968db72475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9036df5e1b5e3823377be9c5cea23c29bd4ce56780c46da7f1d524f82cb44eeb"
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/27/79/df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cf/aiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
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

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/07/93/3618b68b4ba6b54bc97b5fd7d90e4981471edfaf51c8321a29a3c76cf47c/asgiref-3.4.1.tar.gz"
    sha256 "4ef1ab46b484e3c706329cedeff284a5d40824200638503f5768edb6de7d58e9"
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
    url "https://files.pythonhosted.org/packages/ed/2d/627bd81c6193aa94b202f8998a2863d5b0a0902526b4291122dd8651fad8/censys-2.0.3.tar.gz"
    sha256 "12d51f36e96cb3344dfefa9131dbeef59333c56341001742e005f18d70b5d46a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8c/5d/66e0777c6702d0f1bc238aca5ef4f8914eb564b27a04c87e158cd26bd69a/fastapi-0.65.2.tar.gz"
    sha256 "8359e55d8412a5571c0736013d90af235d6949ec4ce978e9b63500c8f4b6f714"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/3f/a5/05c7c11f7c9f02d8f58959c036ea02da1f62ac9da686a25232c2d1dd79ed/limits-1.5.1.tar.gz"
    sha256 "f0c3319f032c4bfad68438ed1325c0fac86dac64582c7c25cddc87a0b658fa20"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1c/74/e8b46156f37ca56d10d895d4e8595aa2b344cff3c1fb3629ec97a8656ccb/multidict-5.1.0.tar.gz"
    sha256 "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/75/cd/eac8908d0b4a4b08067bc68c04e52d7601b0ed86bf2a6a3264c46dd51a84/orjson-3.6.3.tar.gz"
    sha256 "353cc079cedfe990ea2d2186306f766e0d47bba63acd072e22d6df96c67be993"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/25/5a/ed8cc3340b7e83a5e572b5d27387a968a7e52b1e3c269442076ca902b7ba/pycares-4.0.0.tar.gz"
    sha256 "d0154fc5753b088758fbec9bc137e1b24bb84fc0c6a09725c8bac25a342311cd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684/pydantic-1.8.2.tar.gz"
    sha256 "26464e57ccaafe72b7ad156fdaa4e9b9ef051f69e175dbbb463283000c05ab7b"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/fd/f8/d1c597ce15f3fd32ebdec9695da97a1af6e102c1ad8f9de32db84b05986c/pyee-8.1.0.tar.gz"
    sha256 "92dacc5bd2bdb8f95aa8dd2585d47ca1c4840e2adb95ccf90034d64f725bfd31"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "pyppeteer" do
    url "https://files.pythonhosted.org/packages/07/67/a7eca24bf7620e11ba8be87a8c8eee5f3be0b2416aa942526b30d0348800/pyppeteer-0.2.5.tar.gz"
    sha256 "c2974be1afa13b17f7ecd120d265d8b8cd324d536a231c3953ca872b68aba4af"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/b3/17/1e567ff78c83854e16b98694411fe6e08c3426af866ad11397cddceb80d3/redis-3.5.3.tar.gz"
    sha256 "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/42/6e/549283c6f8b9fff54ee8bd35558eb51d3796b1f71509d3385011d9a8c857/rich-10.3.0.tar.gz"
    sha256 "a83bff83309687e1859c75b499879738b135d700738dd2721c22965497af05bd"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c8/87/ba5671b333f1016a306f2e762fe762fbc9c3696614f6db3ce6171641005f/shodan-1.25.0.tar.gz"
    sha256 "7e2bddbc1b60bf620042d0010f4b762a80b43111dbea9c041d72d4325e260c23"
  end

  resource "slowapi" do
    url "https://files.pythonhosted.org/packages/fe/1d/323ab4b3364da6ccc51773b4bb1e72aad46a119a6f24a3b4ca4ecaac022d/slowapi-0.1.4.tar.gz"
    sha256 "4062d67b60a6b57e719e15a64bb0f8db92710b9069a55550c6c43661e5adb52e"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/3a/06/ded663a1ddea8b11a2027d88ff0e757f9cdb812310f18bee33ef7270112f/starlette-0.14.2.tar.gz"
    sha256 "7d49f4a27f8742262ef1470608c59ddbc66baf37c148e938c7038e6bc7a998aa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/f2/9c/99aae7670351c694c60c72e3cc834b7eab396f738b391bd0bdfc5101a663/tqdm-4.61.1.tar.gz"
    sha256 "24be966933e942be5f074c29755a95b315c69a91f839a29139bf26ffffe2d3fd"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/ff/ce/fe9cad04133b37ee82feffde94bd1eb84d49896bdb0a26ebeb45e50ae8a3/types-requests-2.25.0.tar.gz"
    sha256 "ee0d0c507210141b7d5b8639cc43eaa726084178775db2a5fb06fbf85c185808"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e9/9e/25d59f5043cf763833b2581c8027fa92342c4cf8ee523b498ecdf460c16d/uvicorn-0.14.0.tar.gz"
    sha256 "45ad7dfaaa7d55cab4cd1e85e03f27e9d60bc067ddc59db52a2b0aeca8870292"
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

    resource("orjson").stage do
      system Formula["maturin"].bin/"maturin", "build", "--no-sdist",
                                                        "--release",
                                                        "--strip",
                                                        "--compatibility", "linux",
                                                        "--cargo-extra-args=--locked"
      venv.pip_install Dir[Pathname.pwd/"target/wheels/orjson*.whl"]
    end

    res = resources.map(&:name).to_set - ["orjson"]
    res.each do |r|
      venv.pip_install resource(r)
    end

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
