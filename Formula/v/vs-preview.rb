class VsPreview < Formula
  include Language::Python::Virtualenv

  desc "Previewer for VapourSynth scripts"
  homepage "https://github.com/Jaded-Encoding-Thaumaturgy/vs-preview"
  url "https://files.pythonhosted.org/packages/f2/91/ba18f65f751c63acd9096f719723edefb4c45bd72be77c424a0086028f14/vspreview-0.20.1.tar.gz"
  sha256 "165dc63c6668794216f70a686becaa309b6dd8730db9915ad97f6d190f238274"
  license "Apache-2.0"
  head "https://github.com/Jaded-Encoding-Thaumaturgy/vs-preview.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jpeg" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "freetype"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "pyqt"
  depends_on "python-matplotlib"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  pypi_packages exclude_packages: %w[certifi matplotlib numpy pillow pyqt6 vapoursynth]
  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/9a/08/7012b00a9a5874311b639c3920270c36ee0c445b69d9989a85e5c92ebcb0/fonttools-4.62.1.tar.gz"
    sha256 "e54c75fd6041f1122476776880f7c3c3295ffa31962dc6ebe2543c00dca58b5d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jetpytools" do
    url "https://files.pythonhosted.org/packages/6e/cb/897da3c1442beccf3269da64c576bbd4c0e041585e935778220603a2effd/jetpytools-2.2.6.tar.gz"
    sha256 "6180736ea31cad431aa8972c9c6c434d59206903e87b9976247c2f64acab722a"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/d0/67/9c61eccb13f0bdca9307614e782fec49ffdde0f7a2314935d489fa93cd9c/kiwisolver-1.5.0.tar.gz"
    sha256 "d4193f3d9dc3f6f79aaed0e5637f45d98850ebf01f7ca20e69457f3e8946b66a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "qdarkstyle" do
    url "https://files.pythonhosted.org/packages/ef/1e/5bf72a61a7636058e25eaa7503c050dae9445de75fad6f71ba08f2174e49/QDarkStyle-3.2.3.tar.gz"
    sha256 "0c0b7f74a6e92121008992b369bab60468157db1c02cd30d64a5e9a3b402f1ae"
  end

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/70/01/392eba83c8e47b946b929d7c46e0f04b35e9671f8bb6fc36b6f7945b4de8/qtpy-2.4.3.tar.gz"
    sha256 "db744f7832e6d3da90568ba6ccbca3ee2b3b4a890c3d6fbbc63142f6e4cdf5bb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/cd/c5/0389f55cdc914005dbf1281d82f16da1cc5ef4696bff0cac8cf2a94b614b/vsjetengine-1.2.0.tar.gz"
    sha256 "1e19eb83de71f42bf55548e1e1c2fafc1cd23a2c93da9373711868ed7ac90cfd"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/9c/94/8d4006eb22839ad169077fd11c70776d4edc7dd3f2e7a192c2cd7608dd78/vsjetpack-1.3.0.tar.gz"
    sha256 "a13bd0b04ac5f89feb1f7a92a14736487d9cfd9b4332fa68126a35955e7a407f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Since this is a GUI application, we can't do much more than check that the version reads.
    assert_match "VSPreview #{version}", shell_output("#{bin}/vspreview --version")
  end
end
