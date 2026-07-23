class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/04/a9/7f7625225c6e7041ab4460bfc5b30a6ebc40bcf6487ee28d5864149124c4/sigstore-4.4.0.tar.gz"
  sha256 "20ffe791c1fa33ce62148c0291b46280d29c1910964d9afac419e9b1a8afc56b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/sigstore/sigstore-python.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40e5e2b3065c272a25df51325da4cb00a2a075c54a87c9e154103fff1a300dcd"
    sha256 cellar: :any, arm64_sequoia: "9e88ca3a12e62a3d2398c0cb3579279b8d8602f9f1e6eea3d16a6502481be7fd"
    sha256 cellar: :any, arm64_sonoma:  "9ce3af1b8a9076e643c6f946a0eb55d17db3fe1fde8653e4fc626c87821eb980"
    sha256 cellar: :any, sonoma:        "b9ff1a8533e188e2344a553dbc622188dbdc5a254db4447813ca363068ebbd3f"
    sha256 cellar: :any, arm64_linux:   "847e47dae4c29e6f7702d5bb8ab48a7574a08728a158a55ae703c1239fd4ac66"
    sha256 cellar: :any, x86_64_linux:  "1ba19e5b74c7b3c8f6eda595d8c6bb6647ffed274caa9234ccc8b0126f038a2d"
  end

  depends_on "pkgconf" => :build # for rfc3161-client
  depends_on "rust" => :build # for rfc3161-client
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@3" # for rfc3161-client
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/74/b7/da07bae88f5a9506b4def6f2f4903cf4c3b8831e560dba8fa18ca08f758f/pyopenssl-26.3.0.tar.gz"
    sha256 "589de7fae1c9ea670d18422ed00fc04da787bbde8e1454aea872aa57b49ad341"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rfc3161-client" do
    url "https://files.pythonhosted.org/packages/35/0d/b9e726d45557d756d2e162bd3ca23f641119c4fd0717b9e4b7519080be10/rfc3161_client-1.0.7.tar.gz"
    sha256 "8c02330b8b09cbf88f2f5f1ecdb6e6b76c0c9bd7c4199a5068ab43b95d7ab8e5"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/b8/11/9623c61604f9b8955248d43fc6a75658bb687c0d3ab65b032b2e43613bd5/securesystemslib-1.4.0.tar.gz"
    sha256 "faea87be0f9c4b4277a5fa1b54bf9bfd807be9a94ab11be6c557dc8b75c43285"
  end

  resource "sigstore-models" do
    url "https://files.pythonhosted.org/packages/c6/ed/5c0ff809f90b19f4e971e17c1ed11f4df60082c6010b32a82054087e91e0/sigstore_models-0.0.6.tar.gz"
    sha256 "c766c09470c2a7e8a4a333c893f07e2001c56a3ff1757b1a246119f53169a849"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/b4/54/102e772445c5e849b826fbdcd44eb9ad7b3d10fda17b08964658ec7027dc/sigstore_rekor_types-0.0.18.tar.gz"
    sha256 "19aef25433218ebf9975a1e8b523cc84aaf3cd395ad39a30523b083ea7917ec5"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/aa/40/25ceaf7f02e18b0d99150d94e200929351a542479c54abb7b92e1fd74b10/tuf-7.0.0.tar.gz"
    sha256 "9d2e6723538e0d5a3e482b6de805fcfe64481448d5853039ba6b06ba541efd7f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    # NOTE: This resource and below do not needed to be kept up-to-date
    # with the latest sigstore-python release.
    resource "homebrew-test-artifact" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz", using: :nounzip
      sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz.sigstore"
      sha256 "1cb946269f563b669183307b603f85169c7b1399835c66b8b4d28d913d26d5f7"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v3.3.0"

    output = shell_output("#{bin}/sigstore verify github sigstore-3.3.0.tar.gz --cert-identity #{cert_identity} 2>&1")
    assert_match "OK: sigstore-3.3.0.tar.gz", output
  end
end
