class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/a1/e8/4de5b5a3ebc1f1b20512159bda3c0379efe0f291eee2cbc876877ee560ba/weaviate_cli-3.4.2.tar.gz"
  sha256 "eb4a3686a45d48bd2f8833af676b2f1c25effd43ef556ec28535b07fce44ce5c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b080069fd121700e5aaf1c5830e8219bda1da970a18d6a8967a1157ac5b75800"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "899002d7154134dab14571072469940bfe4096d66c045c362123dbe15bf33d76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03ec96e255f1d6d602279ae39bda08cba378c28ab753783aaa23c540f42d02ff"
    sha256 cellar: :any,                 arm64_linux:       "1300141c7bf56be78fd170f1b8d29c46a52c5266f242e29306982cd1c72b6e46"
    sha256 cellar: :any,                 x86_64_linux:      "adf6a9041e4c9c60dff318cb9ce0f1a046ea9ed3d9a7da8cebf94ae301468c68"
  end

  depends_on "cmake" => :build # contourpy
  depends_on "meson" => :build # contourpy
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "numpy" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[certifi cryptography numpy pillow pydantic]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/c9/dc/087c08741a98d234c9b98beef8a28d3c309f814d14b6156422c5815bf6d6/authlib-1.9.1.tar.gz"
    sha256 "5c7d9848f47cac340f060f76ae0bc09b59f5c8e89cc1bb032d4370a0c55b5974"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/83/5a/a55177dd22553a277388e8a1b3220e92de91bacb28356cdc73caa240121d/contourpy-1.4.0.tar.gz"
    sha256 "20156f5a1ac4f8ce02656e39a61e82164a3d359796dc8026f75b062783d500e1"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/33/6c/b8793efc2f00a912ef17cf0b61b717cddf34607499efcb8a32238c119368/faker-40.43.0.tar.gz"
    sha256 "02fae4327c03a4a6315e1b428a3878f435bfc276c93435ea349b95c0c9372361"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/94/36/102e180f8f5dbaee88b26595b01ca8aa80bf4e62128d9aa94265b3996c96/fonttools-4.67.0.tar.gz"
    sha256 "3cb57e6600ca77c0b1729cf8adc23bc0652633a37f18cfa934d9c7bc3de25519"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/06/8a/3d098f35c143a89520e568e6539cc098fcd294495910e359889ce8741c84/grpcio-1.78.0.tar.gz"
    sha256 "7382b95189546f375c174f53a5fa873cef91c4b8005faa05cc5b3beea9c4f1c5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/e4/06/b56dfa750b44e86157093bc8fca0ab81dccbf5260510de4eaf1cb69b5b99/importlib_resources-7.1.0.tar.gz"
    sha256 "0722d4c6212489c530f2a145a34c0a7a3b4721bc96a15fada5930e2a0b760708"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/bd/15/48ff246732232d35ee234228def22b52455fcc55577f06146602399a29b0/joserfc-1.7.7.tar.gz"
    sha256 "471d0fd12a5a0d1c0942de280f39efe6f597878315033270b504d4d006d25510"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/ba/07/bd78e6a8fae171ea041ef5bba3ed21a003522fa088834b069b1909981f30/kiwisolver-1.5.1.tar.gz"
    sha256 "f1303ef2eec81262a4b708c3e858afe58d7c75ad91c1c05266eda7673369859a"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/e7/c8/9aa712a0afb882649424dd8de8ad9aa6235e796e84c6052e8f6dc1598d0d/matplotlib-3.11.2.tar.gz"
    sha256 "cec596316640f2b394b8f0daa0ea61a8eae82d017b620b9f202befb972a59ea4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/74/ba08d81e668ccfe8658d7520a307e63c19862c08eb4ccb26f356c5239a7a/prettytable-3.18.0.tar.gz"
    sha256 "439217116152244369caf3d9f1caf2f9fe29b03bd79e88d2928c8e718c95d680"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/df/f15f80383f152452d8985b36d95cb8751f901a3e0ff4cd27f7e118f168e2/python_dateutil-3.0.0.tar.gz"
    sha256 "7ebcb3c29a92f3ceafe79a7a48a5c45677e9e004bbeec5742ac0bbb00560b7a2"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/7b/3f/4fe7905f73ba0e768baa102a09ba9458f2f0bb4a676102e1fd7a3cb55c2b/validators-0.36.0.tar.gz"
    sha256 "92ad9ed00bbed320b784cec0ea90b213cf08904cf605b3d0852cfa4108e32a2c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/cc/20/eef7a37733c8616179cf8eaa2137c9e4e9e7cbd54d329e9185ab445f2ed4/weaviate_client-4.24.1-py3-none-any.whl"
    sha256 "787df83277dd6afaf852770d07deb97eec603e900c670777e173a0474e1f4f40"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"weaviate-cli", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end
