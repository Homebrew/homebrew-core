class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https://shub.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/41/c0/e4cd695b5335dab990dafe0e773382f509d6d8cf77124ca523a66e928439/shub-2.18.1.tar.gz"
  sha256 "4ede0607380bad7df43160dcd0401b47eee309a37fdaf098d6a4621bbfe76a2b"
  license "BSD-3-Clause"
  head "https://github.com/scrapinghub/shub.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0be5433f79d9b9649dc67a500454f3b3f0898a81fffa228a25234f978d33659"
    sha256 cellar: :any, arm64_sequoia: "f7b168b1c0dbbd90f9b5c6ab91b97542884a9c9ca3118d86aa8e809d5dac0a8c"
    sha256 cellar: :any, arm64_sonoma:  "15407913edc7f2fee6d3c4da9ae704aa1ad1dbf99b1607a0f3c3139650321af2"
    sha256 cellar: :any, sonoma:        "220f8f0dd3115172559eca92e27362a16e5b2927cc875e355d0ff1d792e014fd"
    sha256 cellar: :any, arm64_linux:   "7eeaacaf4c0b84ebdb6ec9207dd9b79796f4a1cbc37d2a3a802e176573eb1288"
    sha256 cellar: :any, x86_64_linux:  "585852bfd9ea92701bb0802be806ad6d2a6b55937f3d5cbee28a1c9159b1cac9"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "scrapinghub" do
    url "https://files.pythonhosted.org/packages/9a/76/7c82eee31f76f4c52ae632566bb49875e8fb63c19168f928f9ea2cb0a9c5/scrapinghub-2.7.0.tar.gz"
    sha256 "df9b98481d1f6ca7ad8b56fdd05699ed4365c1d44718e226484cd32c0586ee89"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"shub", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}/shub schedule 2>&1", 2)
  end
end
