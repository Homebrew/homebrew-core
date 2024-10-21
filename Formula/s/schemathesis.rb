class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/19/35/81a5be7da5afcd7f142f8930ad37ff5f3b03a97db7912288975c2d8eacd4/schemathesis-3.38.0.tar.gz"
  sha256 "16beb6db3bc123f2388de6545ede1795677a354fcac1cd14b01baa7fa745d3e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab6a56dfa258ab10c52fb59edbd8fe7be8d833f344fa73a1ad3e1aaff8c65e56"
    sha256 cellar: :any,                 arm64_sonoma:  "2f652d3813c38893f3b314039ea660823165d76797a6af36ae38f1bc9d16b829"
    sha256 cellar: :any,                 arm64_ventura: "0013874be5c7fbf6e82bb8fb7c7e462c14d76a4dfa12bd42db7e196875f9f7b0"
    sha256 cellar: :any,                 sonoma:        "f5a3722c642467d2540ce375ff0f93c7490399a0d076d88952343cd678365e33"
    sha256 cellar: :any,                 ventura:       "3be97d04bd59383c920afcc29fdadf51c01df8f70b2da36d7d890fbcb6077218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6012d635d8acaf2e9c2c588fbea4ddf3439bac4889c84c7e315c221042943ea5"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "st", because: "both install `st` binaries"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/9f/09/45b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546cc/anyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/2e/b5/ebc6fe3852e2d2fdaf682dddfc366934f3d2c9ef9b6d1b0e6ca348d936ba/graphql_core-3.2.5.tar.gz"
    sha256 "e671b90ed653c808715645e3998b7ab67d382d55467b7e2978549111bbabf8d5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/6d/0f/fc074af5572e3faeadce77c9bc82d7bd3bacd522ffae8f76599ecf1af8e3/harfile-0.3.0.tar.gz"
    sha256 "23be8037e1296bb4787a15543a37835ed91f408c8296988f9ba022a44accad9e"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b6/44/ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6/httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/a3/f1/bfabc2a077d90809831549df1450cf8f4c06c7a1017c48ae39469b7737fe/hypothesis-6.115.3.tar.gz"
    sha256 "d4efc8c7371bd4ec906d2777f1f18fee5539e47b3d7c7cdc93d1026ad35d9b33"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/14/65/edad164cc4d359bff8c36a2294ab7c60c95a528b600bc22a8f7d9928f9e1/hypothesis_graphql-0.11.1.tar.gz"
    sha256 "bd49ab6804a3f488ecab2e39c20dba6dfc2101525c6742f5831cfa9eff95285a"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/4f/ad/2073dd29d8463a92c243d0c298370e50e0d4082bc67f156dc613634d0ec4/hypothesis-jsonschema-0.23.1.tar.gz"
    sha256 "f4ac032024342a4149a10253984f5a5736b82b3fe2afb0888f3834a31153f215"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/3e/b6/a812da6cbcb3861c4389fc42114a77d3628d2a9948fbc5f308c35fecaed0/pyrate_limiter-3.7.0.tar.gz"
    sha256 "dc1e6d2c80b559f3333cb44bd822bd558f5a47946dc50cce4263a9c1c5fd8067"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/8b/6c/62bbd536103af674e227c41a8f3dcd022d591f6eed5facb5a0f31ee33bbc/pytest-8.3.3.tar.gz"
    sha256 "70b98107bd648308a7952b06e6ca9a50bc660be218d53c257cc1fc94fda10181"
  end

  resource "pytest-subtests" do
    url "https://files.pythonhosted.org/packages/67/fe/e691d2f4ce061a475f488cad1ef58431556affea323dde5c764fd7515a70/pytest_subtests-0.13.1.tar.gz"
    sha256 "989e38f0f1c01bc7c6b2e04db7d9fd859db35d77c2c1a430c831a70cbf3fde2d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3987" do
    url "https://files.pythonhosted.org/packages/14/bb/f1395c4b62f251a1cb503ff884500ebd248eed593f41b469f89caa3547bd/rfc3987-1.3.8.tar.gz"
    sha256 "d3c4d257a560d544e9826b38bc81db676890c79ab9d7ac92b39c7a253d5ca733"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/78/53/c3a36690a923706e7ac841f649c64f5108889ab1ec44218dac45771f252a/starlette-0.41.0.tar.gz"
    sha256 "39cbd8768b107d68bfe1ff1672b38a2c38b49777de46d2a592841d58e3bf7c2a"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/cd/64/6debec8fc6e9abde0c7042145dc27a562bd1cd79350a55b80bf612a10ccb/starlette_testclient-0.4.1.tar.gz"
    sha256 "9e993ffe12fab45606116257813986612262fe15c1bb6dc9e39cc68693ac1fc5"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/d4/19/b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273/tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/31/f8/f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16e/types-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/fe/f8/53150a5bda7e042840b14f0236e1c0a4819d403658e3d453237983addfac/webcolors-24.8.0.tar.gz"
    sha256 "08b07af286a01bcd30d583a7acadf629583d1f79bfef27dd2c2c5c263817277d"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0f/e2/6dbcaab07560909ff8f654d3a2e5a60552d937c909455211b1b36d7101dc/werkzeug-3.0.4.tar.gz"
    sha256 "34f2371506b250df4d4f84bfe7b0921e4762525762bbd936614909fe25cd7306"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3e/83/529d9cb66a6b3ba120c4a52bec8299f495f9446b749cb1110c89ffb46704/yarl-1.15.5.tar.gz"
    sha256 "8249147ee81c1cf4d1dc6f26ba28a1b9d92751529f83c308ad02164bb93abd0d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "openapi": "3.0.3",
        "paths": {}
      }
    EOS
    output = shell_output("#{bin}/st run ./example.json --dry-run")
    assert_match "Schemathesis test session starts", output
    assert_match "Specification version: Open API 3.0.3", output
    assert_match "No checks were performed.", output
  end
end
