class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/ec/37/3eef8688ca933f29b21eff6d9de4ddebe39b4521b62f17a51720d036d53e/sigma_cli-4.0.0.tar.gz"
  sha256 "161a84ea5fabd649701cedd5e49fd16f2debecbac43c56917d6180f32ac15d8d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e71fbb4c1723c23b628df3d941c94cd38a8b84604ab12cbfdf63d0fd2d6c2740"
    sha256 cellar: :any, arm64_tahoe:       "970f3f90080407251849b301cf6590e083810c6b97ac33cc346db38540cbc42d"
    sha256 cellar: :any, arm64_sequoia:     "67f2b1d9616b79d4c9c918af955efcbfd145bcf5abb074760a51e1f036e028e8"
    sha256 cellar: :any, arm64_linux:       "02cc5b50cc68a9d6f4ed17e6fb9b40425586fabed4bb211cbfc0482132bae288"
    sha256 cellar: :any, x86_64_linux:      "98ab5a1f4d22e000d79c9496e4ef1b23256a00ee93beea395cc65186aae3ce71"
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
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diskcache-community" do
    url "https://files.pythonhosted.org/packages/9a/b1/ef17a29956f0208c5acbc30247c742739d37135531a0facf26a5752f9382/diskcache_community-5.8.1.tar.gz"
    sha256 "b780ed4b8381487c53cc778599f745784391c4c7af23c528ece049e008be6197"
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
    url "https://files.pythonhosted.org/packages/67/94/2463945ca70f2d5135768c1898545a0df85586d1b0e66cc1842a649134b7/pysigma-2.0.2.tar.gz"
    sha256 "c8fac45d24adfa14aeebcbab95929066116b2dbcc0816498066af56dda039832"
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
    url "https://files.pythonhosted.org/packages/c7/0c/72b85bc2e3a3cf23419a7f8861c1855893f02080e202b631e33cc0d1a94a/types_pyyaml-6.0.12.20261030.tar.gz"
    sha256 "9123d707aa31a3883eeb2cb290537c75246dfcb1c00abed7a70f5419d3bd31ae"
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
