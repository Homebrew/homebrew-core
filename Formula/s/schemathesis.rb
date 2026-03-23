class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/4e/08/d011bb86c7d0a6e4f8fe8614675b582e09ea7cbc1508d2aae2043c9b1fcc/schemathesis-4.13.0.tar.gz"
  sha256 "a2fafe13d20d299d10d166c521f675798d03576ae31899c3bf762aae7efab4e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dfa965f92bcd1b1da5f2c7032e4f94d30ae5328643d6e9196475d28263ea237"
    sha256 cellar: :any,                 arm64_sequoia: "26ac934b90a2d0d7eb7760f5a8897d87f07349a24756c1b0d82022c206244d7a"
    sha256 cellar: :any,                 arm64_sonoma:  "c2f8cd6fc9edecb4f79e14ecc6e18761814aa6b7fd0f78aad8af39ddc4ac86d0"
    sha256 cellar: :any,                 sonoma:        "0fd2122d63732a04903f8abce1979a5719eea99ca1b180fbb99a4c191db7eef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2957c27c121767a5f381fb9a86ae20c5956852c2dac76821fa2565e543214bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ed7921389ef536c873c368e6592f0468ba38f503964152d0990215c576fc32"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/68/c5/36aa96205c3ecbb3d34c7c24189e4553c7ca2ebc7e1dd07432339b980272/graphql_core-3.2.8.tar.gz"
    sha256 "015457da5d996c924ddf57a43f4e959b0b94fb695b85ed4c29446e508ed65cf3"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/88/56/06ebfce8ee11b906db9984d7442edfb05e8eb495ed2f553857c1c793dbd5/harfile-0.4.0.tar.gz"
    sha256 "34e2d9ef34101d769566bffab3c420e147776174308bed1a036ed8db600cabde"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/19/e1/ef365ff480903b929d28e057f57b76cae51a30375943e33374ec9a165d9c/hypothesis-6.151.9.tar.gz"
    sha256 "2f284428dda6c3c48c580de0e18470ff9c7f5ef628a647ee8002f38c3f9097ca"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/47/d7/aa6d3cacb0fa7ae02fe7810c05dad025ce2fef88c817d959a862aab3ed4a/hypothesis_graphql-0.12.0.tar.gz"
    sha256 "15f5f69b6e0b9ad889f59d340e091d7d481471373eb6a8a8591d126aa56e7700"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/4f/ad/2073dd29d8463a92c243d0c298370e50e0d4082bc67f156dc613634d0ec4/hypothesis-jsonschema-0.23.1.tar.gz"
    sha256 "f4ac032024342a4149a10253984f5a5736b82b3fe2afb0888f3834a31153f215"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-rs" do
    url "https://files.pythonhosted.org/packages/d2/7b/40ed0aa40ff2f3bc9bfccf20ea29d9a99199a8eefda26ae9d65601c144fa/jsonschema_rs-0.45.0.tar.gz"
    sha256 "897deffee817fe0f493710221e19bc4d9fedabdba121d9f8e0aa824460d2498d"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/33/0c/6e78218e6ef726be35a4c0a5e2e281e36ddd940566800219e96d13de99ad/pyrate_limiter-4.1.0.tar.gz"
    sha256 "be1ac413a263aa410b98757d1b01a880650948a1fc3a959512f15865eb58dbf3"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/d1/db/7ef3487e0fb0049ddb5ce41d3a49c235bf9ad299b6a25d5780a89f19230f/pytest-9.0.2.tar.gz"
    sha256 "75186651a92bd89611d1d9fc20f0b4345fd827c41ccd5c299a868a05d70edf11"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/81/69/17425771797c36cded50b7fe44e850315d039f28b15901ab44839e70b593/starlette-1.0.0.tar.gz"
    sha256 "6a4beaf1f81bb472fd19ea9b918b50dc3a77a6f2e190a12954b25e6ed5eea149"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/cd/64/6debec8fc6e9abde0c7042145dc27a562bd1cd79350a55b80bf612a10ccb/starlette_testclient-0.4.1.tar.gz"
    sha256 "9e993ffe12fab45606116257813986612262fe15c1bb6dc9e39cc68693ac1fc5"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/61/f1/ee81806690a87dab5f5653c1f146c92bc066d7f4cebc603ef88eb9e13957/werkzeug-3.1.6.tar.gz"
    sha256 "210c6bede5a420a913956b4791a7f4d6843a43b6fcee4dfa08a65e93007d0d25"
  end

  def install
    venv = virtualenv_install_with_resources without: "jsonschema-rs"
    resource("jsonschema-rs").stage do
      # Use ring instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "crates/jsonschema-py/Cargo.toml",
                /^(jsonschema = .*), features = \[/,
                '\1, default-features = false, features = ["resolve-http", "resolve-file", "tls-ring",'
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"st", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/st --version")
    openapi_url = "https://httpbin.dmuth.org/openapi.json"
    output = shell_output("#{bin}/st run #{openapi_url} --phases examples --include-path /ip")
    assert_match "Specification:    Open API 3.1.0", output
    assert_match "No test cases were generated", output
  end
end
