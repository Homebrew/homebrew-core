class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/c5/98/8c1bf0c78f5ea2a3014f4192c5794fa5e9f1331646f4dea60c1a3bfbe169/sigma_cli-4.0.1.tar.gz"
  sha256 "24eb7213fc2d8d9b0577cda7188f256382beba0e9adc7de8907bafd62fd475f9"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b920044d1adac95a0357c03aa79bce885929fc482226313ab3e66c249ead778"
    sha256 cellar: :any, arm64_tahoe:       "113c07ef11920f17c10bfc9c8f4c537b8ecebf43432b7aa82f2b621b944c679f"
    sha256 cellar: :any, arm64_sequoia:     "f2b4810f30756e9bfa99170442ceec7b3bbd51272af19862118a4400ac23eef8"
    sha256 cellar: :any, arm64_linux:       "452809276aabde7c474250797540db1b9284ae836a23edb922807423924f513b"
    sha256 cellar: :any, x86_64_linux:      "11c08b0f007d38a632299b0418938b6f4f6da1b9a9ace60ab946875d5363170d"
  end

  depends_on "pybind11" => :build # for `google-re2`
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "re2" # for `google-re2`

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "pysigma-backend-sqlite"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diskcache-community" do
    url "https://files.pythonhosted.org/packages/37/be/7d958592a9b2867896a464e5d9cfe7110b7f53ffa4bcfba330364fbbda06/diskcache_community-5.8.5.tar.gz"
    sha256 "f9d771b4ab53606cd9a4111d6dd065370e6a42eb2a6c22ea22d6558b85e62f12"
  end

  resource "google-re2" do
    url "https://files.pythonhosted.org/packages/6b/60/805c654ba53d685513df955ee745f71920fe8e6a284faf0f9b9dc19b659c/google_re2-1.1.20251105.tar.gz"
    sha256 "1db14a292ee8303b91e91e7c37e05ac17d3c467f29416c79ac70a78be3e65bda"
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
    url "https://files.pythonhosted.org/packages/67/67/bd53dc762c2e7728b7b32bdbe59ecb74ae6bc6b7609e5063e6e44553b44f/jq-1.13.0.tar.gz"
    sha256 "e62bdddeab3b8a0a404581a7bb6f1e8c4cc6082280870031f746074f4cac52c0"
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
    url "https://files.pythonhosted.org/packages/f9/1e/4d5d0bac0fba32895222f0d01217629b0057e983f3ebd2bd3b9eeb6a8ae9/pysigma-2.1.0.tar.gz"
    sha256 "b800923786ace5bc90bd35f488d81b7a2b86e04856f213f5de52c05f876901d1"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/38/46/5bea3a7e1004c3d9b7d94ff131311687b79adc6beb0db39926729872ca84/pysigma_backend_sqlite-2.1.1.tar.gz"
    sha256 "df500e04a1589b8604436bdb0106d4b89a7ab31159b59789be9435fdd255a35f"
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
    url "https://files.pythonhosted.org/packages/80/49/96041fdb54de08a5b47bcfcbb4881873b25bae367d1e4dec79d19dfeb84b/types_pyyaml-6.0.12.20261111.tar.gz"
    sha256 "c511f563eaf820b948c4ff6f43fe0b9d48b227be442a69058d9f68f139cae1fb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  def install
    # `google-re2` detects CI to build `re2` but we skipped to use brewed one
    ENV["GITHUB_ACTIONS"] = nil

    # Otherwise compilation of `google-re2` fails with the following error:
    # $HOMEBREW_PREFIX/include/absl/base/policy_checks.h:81:2: error: "C++ versions less than C++17 are not supported"
    ENV.append "CXXFLAGS", "-std=c++20"

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
