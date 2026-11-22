class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https://tmt.readthedocs.io"
  url "https://files.pythonhosted.org/packages/a6/c8/997f3ae3c18701ca67a826e11ae9ec05766bd5ec7a8759d521fda923052a/tmt-1.81.0.tar.gz"
  sha256 "9075340d1f80e4416efc23f96c1ad50b57a4f1cf72aa3647a29804bcee1d539a"
  license "MIT"

  bottle do
    manifest_sha256 "ff6399100d97b3fe139be68c077936119ec1f23d644d7c434f90223d34469a77"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcebc0c50907ad74e365792462c2edd4228f85b86e36971baabbb8275ba0b60a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1898fdc2a16381c6efd9cd8ff9e4c99d1857a9b4d05aacf5e90d499f77bec16a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e71cd584ced49bb076422a2a862174d4181a66927e0d299bdaeab1231e9f27bd"
    sha256 cellar: :any,                 arm64_linux:       "14022942555718d2d2ebdd3fcca684b637da0cf1299bbd4f321c2818451392ef"
    sha256 cellar: :any,                 x86_64_linux:      "08e680392f4f4e83af9f7cd1e1a34a1a83485e4c2583ed0c913e7dcc52bd5f6e"
  end

  depends_on "beakerlib"
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic", "rpds-py"]

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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/52/aa/8ccff8da9a27e089727fcffd3c5b61708383217e47eb1e1b8af37b1dd166/filelock-4.2.12.tar.gz"
    sha256 "7e7da24d3ac39268b0f156e56870001de44886318f092f9d851e692f7114d6dd"
  end

  resource "flexcache" do
    url "https://files.pythonhosted.org/packages/55/b0/8a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1/flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https://files.pythonhosted.org/packages/82/99/b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702/flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "fmf" do
    url "https://files.pythonhosted.org/packages/2c/fe/aed3f3befc18d725776c10fe621790002671d0c4d50a6287d71fa371cf90/fmf-1.7.0.tar.gz"
    sha256 "131b557786b912f99d49d8dcc84196e3c2f39c5ce5ffe8b78e48150afd380dc3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/d3/b0/cef9c8913ebe959d97b2d57b1fc2a77a4291c4f2bd4dc3fe4d3313c938ea/pint-0.26.2.tar.gz"
    sha256 "391e5d2fc01fdb121c113b8eb47386688575542c1f5144c465ff318bf5133573"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"tmt", shell_parameter_format: :click)
  end

  test do
    # fmf searches for a tree root up to `/`, which the sandbox cannot read
    (testpath/".fmf").mkpath
    (testpath/".fmf/version").write "1\n"

    output = shell_output("#{bin}/tmt init --force --template mini project")
    assert_match "Initialized the fmf tree root", output
    assert_match "Applying template 'mini'", output
    assert_match <<~YAML, (testpath/"project/plans/example.fmf").read
      execute:
        how: tmt
        script: tmt --help
      summary: Basic smoke test
    YAML

    assert_match version.to_s, pipe_output("#{bin}/tmt --version")
  end
end
