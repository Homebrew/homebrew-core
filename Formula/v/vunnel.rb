class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https://github.com/anchore/vunnel"
  url "https://files.pythonhosted.org/packages/0e/22/6a823c9a42a412b35597120fe7ab602c00674f7b28570df535c938fd186d/vunnel-0.67.0.tar.gz"
  sha256 "c049421d721f0f5b734982c2cfdef8b11f7e9444c49a8ceee0c7daa85c5ab5d4"
  license "Apache-2.0"
  head "https://github.com/anchore/vunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a782f99b3c6ba16c661b326db48f8eac1661bc067c4e92a0471b6a498e4da190"
    sha256 cellar: :any, arm64_tahoe:       "9b340057d801910a21e6bb564265f6cb91d54c249082ccbd411acf542439ca4a"
    sha256 cellar: :any, arm64_sequoia:     "f71c081e930bd145a1459f5cc312e2cfee844daf7e890c981712d0374bf43e74"
    sha256 cellar: :any, arm64_linux:       "38806f010bcc7b2dbe89516bb4671d796de808a488f210325e8d1049b6ae56d5"
    sha256 cellar: :any, x86_64_linux:      "a79dfdcee3df63d3f165b43a6d33b7ad66fd91cc39a48fc239310b5922bc1965"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
  end

  resource "cvss" do
    url "https://files.pythonhosted.org/packages/a5/f6/1f7d315de23f39bbc32b94bb6b33a1b6124856037bfaa3f8bdb1a49584fa/cvss-3.6.tar.gz"
    sha256 "f21d18224efcd3c01b44ff1b37dec2e3208d29a6d0ce6c87a599c73c21ee1a99"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/75/61/4066af787ed25bfca02c3edd2d7fd489b1b5ca27b54b400b187e5f2865e7/ijson-3.6.0.tar.gz"
    sha256 "ec8f9265524e724905ecf00bdd061c374baaa8d5045ef50425695fb06efb45f5"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a6/91/0ef39e4ef4407de276289a3759977ac3a8cc546f59c55d725750eae3f41b/importlib_metadata-10.2.0.tar.gz"
    sha256 "9413a2029fd9ca5669d27f1386071bbfe3c7ebca0545692ec975088241fe1d79"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/01/e1/2069291243c926a2ff1cd706c7f3eeb9b62144bf60f77c9fb9ff2fb26bd3/iniconfig-2.3.1.tar.gz"
    sha256 "67f4b9c50da0dedf52af349e7749a80a9057a5031199791b906c3bb3ae878960"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mashumaro" do
    url "https://files.pythonhosted.org/packages/09/18/6383ce957a0551d8704936ffef1ecf0b0c620543999a44f9adf6c5f30888/mashumaro-3.23.tar.gz"
    sha256 "ed69d5bc548c76efbb5286cc0e541a6b8796e621385f986e25b750364011abf5"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "oras" do
    url "https://files.pythonhosted.org/packages/c5/d2/dc4a3eb07ac779455dbfbc85cd396025ad72450ed7673a323c685cfb6774/oras-0.2.43.tar.gz"
    sha256 "761f2b518fce50e5e9482975363ff0230f63fc65f84c09510fbcc301782a047c"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/79/42/bb4641652e58dedeac2ec51abc1f8cae4fee4ec63899a0999016229a0f2a/pytest-9.2.0.tar.gz"
    sha256 "97c4f3b1f3c7414aa36465e09b8220f1d03627993bd51b1282e193753c80557b"
  end

  resource "pytest-snapshot" do
    url "https://files.pythonhosted.org/packages/9b/7b/ab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34/pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "ruff" do
    url "https://files.pythonhosted.org/packages/86/cc/7b71512eb8b49926efb887cc66c74dd993642943c29eba51a877f6b85692/ruff-0.17.5.tar.gz"
    sha256 "625e57d80cd43352d12ea81690f3eac46cddc8c0f35026d137fb0f157f94592e"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/3f/69/b87a540f6888ebc1f63a6e6138e8dc0827331a9be7c5eb15e3bd40a76281/sqlalchemy-2.1.9.tar.gz"
    sha256 "d700a8b2edfb26282a470333d6bc4a454c4acda4d201a3bea7b72fa76c217d28"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/69/19/8e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678b/toposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "xsdata" do
    url "https://files.pythonhosted.org/packages/f3/b8/7b301b80494a750dba431d3d0a800e0e80c91903e8891eef78ead8f95120/xsdata-26.10.tar.gz"
    sha256 "4bc944d9fa3955f84ecebb83c677e2f681687c002a777731a21104e8360a7522"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/c9/b5/3d11d3830ace56d67ea83136c24385c3b07da5a9bc62b73b0b94ac096da3/xxhash-4.1.0.tar.gz"
    sha256 "c9b288e4c1f5dae54417bc8a05e6f6daf505783d916b4783f4dd2f2e7d5db486"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/18/05/ba1458dee0ac485b2a01071c1b88f5199fe878a485df482e10e1ef2205cc/zipp-4.1.2.tar.gz"
    sha256 "cf474b90b07ea932637e17c6b9479de2b2882900b0d311bdaf4f5c000a15a97f"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    ENV["XXHASH_LINK_SO"] = "1"

    venv = virtualenv_install_with_resources without: "zstandard"

    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end

    generate_completions_from_executable(bin/"vunnel", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vunnel --version")

    assert_match "alpine", shell_output("#{bin}/vunnel list")
  end
end
