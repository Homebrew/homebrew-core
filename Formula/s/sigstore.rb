class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/11/10/349d460d275dccade8d5aa29e15290a7febb0c0bdeab8f2cd9d0ee61d9db/sigstore-4.6.0.tar.gz"
  sha256 "dc9a7bd0e35ee381a6f70281f520f858d12b34a997c023f7dec835c0095a5067"
  license "Apache-2.0"
  head "https://github.com/sigstore/sigstore-python.git", branch: "main"

  bottle do
    manifest_sha256 "1980f9ce823ad4fe09727132921cafa3c9ffb6b8dc227abfdb42e21aed14dac4"
    sha256 cellar: :any, arm64_golden_gate: "12bad4eada636addb7c4e7e38765c2de97b7b6b4b62972bd27f686641eea9e9b"
    sha256 cellar: :any, arm64_tahoe:       "35ac5b6a0fa92923a01d5954bb6ff7bdcbabeb663d918559468f43c3318a3708"
    sha256 cellar: :any, arm64_sequoia:     "177bf3462adc9b8068359a9e7ff58dd2d75ce0ff37089d460730e826e0439f2c"
    sha256 cellar: :any, arm64_linux:       "16f467b90db424af2f8a6c319f990a4e60dc5b78dd2c13550110ec9640288caf"
    sha256 cellar: :any, x86_64_linux:      "9cc49fd61c3332d3efb8c7e616aebed18b8b7449a13c31c040875c303a9282dd"
  end

  depends_on "pkgconf" => :build # for rfc3161-client
  depends_on "rust" => :build # for rfc3161-client
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@4" # for rfc3161-client
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic]

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/c0/4d/f5e9d9de19f4b8f9e33d802fe3efb0ef96e88d4d6d45d604f335bef2f1ef/email_validator-2.4.0.tar.gz"
    sha256 "be487bc50bc3bd832a98515a55a15649d9bec06d954fa178663190714b6c4ee1"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "rfc3161-client" do
    url "https://files.pythonhosted.org/packages/56/53/e2f526fb6957023180c928448e2dd71b03b35038c315aed2d12d9a77c3af/rfc3161_client-1.0.9.tar.gz"
    sha256 "66997415086d2c6e5d57a2d315157b32a9c3f4f1312877ca8eb55e2e0ddf8ce4"
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
    url "https://files.pythonhosted.org/packages/6c/b7/68ce74b4c3ab753c2de907d035a4102b4510729393184af3c7bdfee04d18/securesystemslib-1.6.0.tar.gz"
    sha256 "b16e07c32bb41174c2ee2fb18f478ebe0d52e0e7c1fb085ce89c990452a35977"
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
    url "https://files.pythonhosted.org/packages/9c/dd/52e7390cbac308e6b1cfe6be9bc3a96fe26326d5893cc297a52bb72792a9/tuf-7.0.1.tar.gz"
    sha256 "5ada1db78da3518fa851e28588f4b2249b8662a28ae528f54afa2a1de541fb31"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # NOTE: This resource and below do not needed to be kept up-to-date
  # with the latest sigstore-python release.
  resource "homebrew-test-artifact", :test do
    url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz", using: :nounzip
    sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"

    livecheck do
      skip "Test fixture"
    end
  end

  resource "homebrew-test-artifact.sigstore", :test do
    url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz.sigstore"
    sha256 "1cb946269f563b669183307b603f85169c7b1399835c66b8b4d28d913d26d5f7"

    livecheck do
      skip "Test fixture"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v3.3.0"

    output = shell_output("#{bin}/sigstore verify github sigstore-3.3.0.tar.gz --cert-identity #{cert_identity} 2>&1")
    assert_match "OK: sigstore-3.3.0.tar.gz", output
  end
end
