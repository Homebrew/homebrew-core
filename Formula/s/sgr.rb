class Sgr < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for Splitgraph, a version control system for data"
  homepage "https://www.splitgraph.com/docs/sgr-advanced/getting-started/introduction"
  url "https://files.pythonhosted.org/packages/dd/61/7d6cf822edb39d2426f6f185c7fc4de0ad4b80e0da3e5f50d94952795c11/splitgraph-0.3.12.tar.gz"
  sha256 "76a4476002b5ac5a2b9fba36b6fcffd85b878bcc25f5aae411387e04a5532459"
  license "Apache-2.0"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e4177ff9fefc0e71aa7176507e87d7a89777c5aa828a294e0495d31fb358d98a"
    sha256 cellar: :any,                 arm64_sonoma:   "307cb0fe6d3dc16b5015834648bfbe002dae28edcb3277129db1a8fae787e20c"
    sha256 cellar: :any,                 arm64_ventura:  "8ea136e242a1657b9659d43de45387b1a1d2ba62cfa2c50db5cc0512d3565067"
    sha256 cellar: :any,                 arm64_monterey: "c2dd65f7bf656db480a9f73f500a71a29e81f896d973a96ca2f57d741384ee9b"
    sha256 cellar: :any,                 sonoma:         "83e352482d42295813c076f9e7d081784075bc04633cfe7b40d1a2b60cfea9a8"
    sha256 cellar: :any,                 ventura:        "5753957d007902c1b06387830292724f24465dc6aa653b4e5a90ccfc814ef60d"
    sha256 cellar: :any,                 monterey:       "741bfd746d6e30b17cfa61476453776281a8aafebd3395cca842dc056c3cb455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45aff3df501154d9f7b624139cfd90c391dea090c73ab5bbff1b99a2d382a0f2"
  end

  depends_on "cython" => :build # TODO: remove with newer `pglast` (4.4+)
  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libpq" # for psycopg2-binary
  depends_on "openssl@3"
  depends_on "python@3.12"

  # Manually update `pglast` from ==3.4 to support python 3.11
  # https://github.com/splitgraph/sgr/pull/814

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/31/fa/57ec2c6d16ecd2ba0cf15f3c7d1c3c2e7b5fcb83555ff56d7ab10888ec8f/argon2_cffi-23.1.0.tar.gz"
    sha256 "879c3e79a2729ce768ebb7d36d4609e3a78a4ca2ec3a9f12286ca057e3d0db08"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/b9/e9/184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66e/argon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "asciitree" do
    url "https://files.pythonhosted.org/packages/2d/6a/885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913/asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/64/33/60135848598c076ce4b231e1b1895170f45fbcaeaa2c9d5e38b04db70c35/joblib-1.4.2.tar.gz"
    sha256 "2382c5816b2636fbd20a09e0f4e9dad4736765fdfb7dca582943b9c1366b3f0e"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/f1/1c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263/jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "minio" do
    url "https://files.pythonhosted.org/packages/ea/96/979d7231fbe2768813cd41675ced868ecbc47c4fb4c926d1c29d557a79e6/minio-7.2.7.tar.gz"
    sha256 "473d5d53d79f340f3cd632054d0c82d2f93177ce1af2eac34a235bea55708d98"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/02/fc/067a3f89869a41009e1a7cdfb14725f8ddd246f30f63c645e8ef8a1c56f4/parsimonious-0.8.1.tar.gz"
    sha256 "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b"
  end

  resource "pglast" do
    url "https://files.pythonhosted.org/packages/88/df/201bb63cd9777007b89070b23e6bfb00e6da0ef2cbb9d8a4fd3df4c257e1/pglast-3.4.tar.gz"
    sha256 "d2288d9607097a08529d9165970261c1be956934e8a8f6d9ed2a96d9b8f03fc6"
  end

  resource "psycopg2-binary" do
    url "https://files.pythonhosted.org/packages/fc/07/e720e53bfab016ebcc34241695ccc06a9e3d91ba19b40ca81317afbdc440/psycopg2-binary-2.9.9.tar.gz"
    sha256 "7f01846810177d829c7692f1f5ada8096762d9172af1b1a28d4ab5b77c923c1c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0d/fc/ccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967/pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2d/aa/e7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beea/rpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/d1/d6/eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251/ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sodapy" do
    url "https://files.pythonhosted.org/packages/ad/1e/d01ef2bc1b6199edfb0d00302fe3642d61a09175dd3e78832c78301b2ab6/sodapy-2.2.0.tar.gz"
    sha256 "58af376d3bb0dc3a1edc7c8cf9938f5de8f558b35e240438dd83647ac3621981"
  end

  resource "splitgraph-pipelinewise-target-postgres" do
    url "https://files.pythonhosted.org/packages/59/54/de6a8a2b6bdb24de8d8fd4a2465532f3523abc750af4dd9d6e5c17ce6a53/splitgraph-pipelinewise-target-postgres-2.1.0.tar.gz"
    sha256 "9d100ac65288ce24a90da159bbbb06f0fdc0871c2815c63bb6417fea7df4894f"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when merged/released: https://github.com/splitgraph/sgr/pull/813
  patch do
    url "https://github.com/splitgraph/sgr/commit/234bcc12d21860852a40e78a22976ae33d2f2f57.patch?full_index=1"
    sha256 "1308f9172de2268cadc7ae7521a0f109df3cdc40d60f4908d69934acb777a2d5"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # TODO: remove with newer `pglast` (4.4+)
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages("python3.12")

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin/"sgr", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    sgr_status = shell_output("#{bin}/sgr cloud login --username homebrewtest --password correcthorsebattery 2>&1", 2)
    assert_match "error: splitgraph.exceptions.AuthAPIError", sgr_status
    assert_match version.to_s, shell_output("#{bin}/sgr --version")
  end
end
