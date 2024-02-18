class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/0b/26/434cc9621adb5bfd3b7ac23cc270e83fad68c6bb2d747fd988d8fb9ec9a6/sigma_cli-1.0.0.tar.gz"
  sha256 "8b1194b604c648892b9d934835bc3882cb5cfe3470e4bc954c21fa00fcb3d217"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fc7767b978ad78cde9f202b7ea13b9d9ebd1d27230da73a82c589cd54706f57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d24ad9e3630751224e6691aa85885fbfb0983b001430bfb7c0a7d166f1cae027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f6e70cad8cfd0e8ff9bc4881ac6f6d2657cfe879be7a12bdbc1a19050dc5f55"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d5ac7b6a7fc30061d83eebf92496683b31500b26a9818a6cf4d3bfb58a178b7"
    sha256 cellar: :any_skip_relocation, ventura:        "ee5c07a425f7306e0a7d61e55e43e83edd26ed0ae925b74e66887213d07bfc77"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4bc16fa641bb6bae5abce4d27210af8daeb7ca729760876adafd199fe0c4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba92694f04fdbdeb23a3103285ce2aeb46b0a37528c4f72b4cd9efc3af3aeb1"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/39/5b/0605372257fde328cba8d65c0030a2bc2a71bd2ad65fca57c03cc840b626/pysigma-0.11.3.tar.gz"
    sha256 "ed68af1c4150fdd55d0bc1f228fb512088162530a0410f9239deca09ec06942b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "Datadog Cloud SIEM backend", output
  end
end
