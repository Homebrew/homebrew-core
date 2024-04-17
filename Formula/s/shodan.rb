class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
  sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  license "MIT"
  revision 1
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, sonoma:         "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, ventura:        "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, monterey:       "118addf700f290f0ad656c87f8159b2b0efcc9e1bab3f28621352977d732b234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd107b771d650ef6e70e22c3754a238d5d0393643606b4583eb2bfc3383d018b"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/2b/69/ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3/requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/db/ed/c92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739/tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/a6/c3/b36fa44a0610a0f65d2e65ba6a262cbe2554b819f1449731971f7c16ea3c/XlsxWriter-3.2.0.tar.gz"
    sha256 "9977d0c661a72866a61f9f7a809e25ebbb0fb7036baa3b9fe74afcfca6b3cb8c"
  end

  # Drop setuptools dep
  # https://github.com/achillean/shodan-python/pull/209
  patch do
    url "https://github.com/achillean/shodan-python/commit/a99fbf53139bad62fe5ba8f41ac130d5212cbf71.patch?full_index=1"
    sha256 "3f674707548497ea79c760697e4cd44afe0e0df4433b3b49af8ea3637903acd7"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end
