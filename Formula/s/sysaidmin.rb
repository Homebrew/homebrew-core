class Sysaidmin < Formula
  include Language::Python::Virtualenv

  desc "GPT-powered sysadmin"
  homepage "https://github.com/skorokithakis/sysaidmin"
  url "https://files.pythonhosted.org/packages/01/d8/f2b32cc85a544d1487bbdda7ec48d214c0e551d2d0ae6bbbb49d707fe297/sysaidmin-0.2.5.tar.gz"
  sha256 "77c40710cead7bdcc6cb98b38d74dd05e1e1c24dbc450e3b983869a7c06da91f"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab1447a16293a706addd85001c911b1543833b531d55feed4c45e74af35042a5"
    sha256 cellar: :any,                 arm64_sonoma:  "243fedb5e15dc31b137ec7ee259d2a994b186c5df8f0951fcca3556959898a5d"
    sha256 cellar: :any,                 arm64_ventura: "ccc927ca39e55adfc4915457466ce57a1f2f672efda5df4ca7aa5ddcc5afa6a9"
    sha256 cellar: :any,                 sonoma:        "5f877f08a4c4dd09c344453f3247641a6ec70249c478b8dd0b4db599e4aadb43"
    sha256 cellar: :any,                 ventura:       "da9a68d50f541d77d345a3fd83a7d7fcfe5cc76df46f8328b0bf7c7b539dbee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9427ceb6af716340329bf39701baef5406c4307fd01fb95397c2510bb5678e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271c17ea3ddb5d63096b9c1978a840c40f7f29cf2326883f158064943da36ec7"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "griffe" do
    url "https://files.pythonhosted.org/packages/a9/3e/5aa9a61f7c3c47b0b52a1d930302992229d191bf4bc76447b324b731510a/griffe-1.7.3.tar.gz"
    sha256 "52ee893c6a3a968b639ace8015bec9d36594961e156e23315c8e8e51401fa50b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/4c/60/8f4281fa9bbf3c8034fd54c0e7412e66edbab6bc74c4996bd616f8d0406e/httpx-sse-0.4.0.tar.gz"
    sha256 "1e81a3a3070ce322add1d3529ed42eb5f70817f45ed6ec915ab753f961139721"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1e/c2/e4562507f52f0af7036da125bb699602ead37a2332af0788f8e0a3417f36/jiter-0.9.0.tar.gz"
    sha256 "aadba0964deb424daa24492abc3d229c60c4a31bfee205aedbf1acc7639d7893"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/95/d2/f587cb965a56e992634bebc8611c5b579af912b74e04eb9164bd49527d21/mcp-1.6.0.tar.gz"
    sha256 "d9324876de2c5637369f43161cd71eebfd803df5a95e46225cab8d280e366723"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/84/51/817969ec969b73d8ddad085670ecd8a45ef1af1811d8c3b8a177ca4d1309/openai-1.76.0.tar.gz"
    sha256 "fd2bfaf4608f48102d6b74f9e11c5ecaa058b60dad9c36e409c12477dfd91fb2"
  end

  resource "openai-agents" do
    url "https://files.pythonhosted.org/packages/83/6e/3e14abef846b9aaaa454d0c2e3353e0c5b4c72806633bf193024319806f3/openai_agents-0.0.13.tar.gz"
    sha256 "6b80315e75c06b5302c5f2adba2f9ea3845f94615daed4706bfb871740f561a5"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/10/2e/ca897f093ee6c5f3b0bee123ee4465c50e75431c3d5b6a3b44a47134e891/pydantic-2.11.3.tar.gz"
    sha256 "7471657138c16adad9322fe3070c0116dd6c3ad8d649300e3cbdfe91f4db4ec3"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/17/19/ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecd/pydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/67/1d/42628a2c33e93f8e9acbde0d5d735fa0850f3e6a2f8cb1eb6c40b9a732ac/pydantic_settings-2.9.1.tar.gz"
    sha256 "c509bf79d27563add44e8446233359004ed85066cd096d8b510f715e6ef5d268"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/88/2c/7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5baf/python_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/86/35/7d8d94eb0474352d55f60f80ebc30f7e59441a29e18886a6425f0bccd0d3/sse_starlette-2.3.3.tar.gz"
    sha256 "fdd47c254aad42907cfd5c5b83e2282be15be6c51197bf1a9b70b8e990522072"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ce/20/08dfcd9c983f6a6f4a1000d934b9e6d626cff8d2eeb77a89a68eef20a2b7/starlette-0.46.2.tar.gz"
    sha256 "7f7361f34eed179294600af672f565727419830b54b7b084efe44bb82d2fccd5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/00/7d/eb174f74e3f5634eaacb38031bbe467dfe2e545bc255e5c90096ec46bc46/types_requests-2.32.0.20250328.tar.gz"
    sha256 "c9e67228ea103bd811c96984fac36ed2ae8da87a36a633964a21f199d60baf32"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/a6/ae/9bbb19b9e1c450cf9ecaef06463e40234d98d95bf572fab11b4f19ae5ded/uvicorn-0.34.2.tar.gz"
    sha256 "0e929828f6186353a80b58ea719861d2629d766293b6d19baf086ba31d4f3328"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin/"sysaidmin --version")

    ENV["SYSAIDMIN_API_KEY"] = "faketest"
    # $ sysaidmin "The foo process is emailing me and I don't know why."
    output = shell_output("#{bin}/sysaidmin 'The foo process is emailing me and I dont know why.' 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
