class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "876c3c23633e1a2516a7a9ec2687164f69809c07aa00fa9d694bf5c7797cc09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b180352f39d35fdfc2950fc0291fb9d990a6961eb686aad5f4313783d0f90170"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b180352f39d35fdfc2950fc0291fb9d990a6961eb686aad5f4313783d0f90170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b180352f39d35fdfc2950fc0291fb9d990a6961eb686aad5f4313783d0f90170"
    sha256 cellar: :any_skip_relocation, sonoma:         "9664d54979c41f2ded4d6eab777cae3baa9eda5f3bda3a934fbb8157c0c460be"
    sha256 cellar: :any_skip_relocation, ventura:        "9664d54979c41f2ded4d6eab777cae3baa9eda5f3bda3a934fbb8157c0c460be"
    sha256 cellar: :any_skip_relocation, monterey:       "f5173c74096a0966433386e0d8a93b5d313090138d8e311d04bdea4fbf71a5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269ef9bf80627292fc29b6dbe882f37355d0c874e04300b4857d2530fad479f9"
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
