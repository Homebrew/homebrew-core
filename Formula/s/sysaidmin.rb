class Sysaidmin < Formula
  include Language::Python::Virtualenv

  desc "GPT-powered sysadmin"
  homepage "https://github.com/skorokithakis/sysaidmin"
  url "https://files.pythonhosted.org/packages/1d/20/83d3990757074c4e43f29da3f306d3ab5e25edcb4bf31aca14ebb4591e4a/sysaidmin-0.2.0.tar.gz"
  sha256 "7e91afa743d60b1b7c9bb5ff6d9b5edc0774bafb687e9b7e550fda0e3acf5aed"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fb9c302497179f9cb51abd6d379ab0e2c7e79c940f8b5efe98c7fe0e56c12d4"
    sha256 cellar: :any,                 arm64_ventura:  "27d4081785eb8389aa07f995fd178b1e8e75264540be237a91b75ec4a7eb0cf9"
    sha256 cellar: :any,                 arm64_monterey: "7676f2a22f2282097a1f034d375f1cb76451dc8adc2a912a2a12a92e497548d4"
    sha256 cellar: :any,                 sonoma:         "6d0cfd48b68ed6da09fa894db866cd3b1ad6d764eec500b28e9483849397c850"
    sha256 cellar: :any,                 ventura:        "4eea2c2e62d727a5a2e909fe4f6cabc66d9940c2fc69bdc7c2c858d99f32a785"
    sha256 cellar: :any,                 monterey:       "76652c90ea831bc1eb4574fd7e4d7725009e8a8ead411fdd5af3856ac712b696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2d699ea60b37f82fae235c6ed47cca0f6729fb6d012784ed448c37bae738fa"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/74/21/6c17ea073a1643611e99a64934cb7d6f0c5ef74c5bd2ecd9ca8f748867a3/openai-1.17.0.tar.gz"
    sha256 "72e6758cec080a3e5a9daf843178c975fed656fe0831919f4dd89bb62431724f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/cd/fc/70fe71ff78f680d584eba9c55a30092f6ef0b9cf0c75a74bd35a24151a83/pydantic-2.7.0.tar.gz"
    sha256 "b5ecdd42262ca2462e2624793551e80911a1e989f462910bb81aef974b4bb383"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/3d/28/d693aab237fca82da327990a88a983b2b84b890032076ee4a87e18038dbb/pydantic_core-2.18.1.tar.gz"
    sha256 "de9d3e8717560eb05e28739d1b35e4eac2e458553a52a301e51352a7ffc86a35"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    # $ sysaidmin "The foo process is emailing me and I don't know why."
    output = shell_output("#{bin}/sysaidmin 'The foo process is emailing me and I dont know why.' 2>&1", 1)
    assert_match "Incorrect API key provided", output

    assert_match version.to_s, shell_output(bin/"sysaidmin --version")
  end
end
