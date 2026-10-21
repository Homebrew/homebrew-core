class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/13/63/f6bae3c67004d3f0f496805d25cf8d7e355c59341b58ae534778e33c17be/sigma_cli-3.1.0.tar.gz"
  sha256 "e87e4f241b309e84f67fb38aa768ddd6d911f90e061c885c0aa16a6dcb7fbad7"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "12e9823b55736f03b8a0cbdbcb6a49097da106db7f44de68b2649ae95a67e619"
    sha256 cellar: :any, arm64_tahoe:       "565430f809112fba99721693959219b23da559ee2b4e94369aa03493c9c12cef"
    sha256 cellar: :any, arm64_sequoia:     "32043e2f46f5a689120f2e57efb777ca89781f941ba1abb9251f79a07d0f60aa"
    sha256 cellar: :any, arm64_linux:       "2cfba78756752f072a62cc315d0b53b9bb4fac2981c88400335c60c969829915"
    sha256 cellar: :any, x86_64_linux:      "8f71c638ef23e16908f330b4bfc24b011e5477949bf0640e9fc93fd40ea00ec7"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "pysigma-backend-sqlite"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "diskcache-stubs" do
    url "https://files.pythonhosted.org/packages/cb/d6/b741a916707520349a3853a3f436aaf5df6e06a2c1499636072b1b3ce45d/diskcache_stubs-5.6.3.6.20240818.tar.gz"
    sha256 "b6eb43899e906b3167a20ac09a9a226f30267a306a96542ea720ebbfc3282796"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/95/ec/3da01457bbd3c6a2fc8fea6736c0b657ffc628e3decbfb1fafcf33dc7dbe/jq-1.12.0.tar.gz"
    sha256 "729b2d3418c8ca7dccfaa66b9fb7a98bec28474212650d27c5c04358ce26f55c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/74/ba08d81e668ccfe8658d7520a307e63c19862c08eb4ccb26f356c5239a7a/prettytable-3.18.0.tar.gz"
    sha256 "439217116152244369caf3d9f1caf2f9fe29b03bd79e88d2928c8e718c95d680"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/8c/ca/ed5d1e86bb08501a0b664500224d5e58d6801a63713ad8f05857b9cf3c1f/pysigma-1.5.1.tar.gz"
    sha256 "5f27ea435bc53480b43f9e385104c6df3d473715321d662a52a1fc283ab0b8db"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/4f/39/a782807e8a59388ba1ac2280d9a95edd0ef2aca5bf19c0083af857619d44/pysigma_backend_sqlite-2.0.0.tar.gz"
    sha256 "fbbdd8853e3ddd256016d7bd968c0e53f7cb83cab2a9d837beb8b87bec45f8fe"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/90/6e/abec85b9013db5b934b0280a6dd104904d84f7bcbaab2e2f3def87ac7463/types_pyyaml-6.0.12.20260906.tar.gz"
    sha256 "f59c1cc05010b833d2d72287bbaa72610106b28d42d89a907313117faba85212"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sigma", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "IBM QRadar backend", output
  end
end
