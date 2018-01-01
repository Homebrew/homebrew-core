class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://github.com/pypa/twine/archive/1.9.1.tar.gz"
  sha256 "1c9841dabb80b8066688f39fea3250982ce9dd38f2af3c69e95c87939306de2e"
  head "https://github.com/pypa/twine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37cd3858e20cb8456053789c75d66767d40d3898dd4ec6725a99ea39220de0a4" => :high_sierra
    sha256 "4d48e4d27b3933ea505f219d84be07f734dbff3e5e7a133ed23a0bcb5288998c" => :sierra
    sha256 "be0b38d0ca616f4c65ca220d238b0e1f64cc8b822350ce0ec804a0e85e57ac16" => :el_capitan
    sha256 "c88b0ffc33039b8cf6027e2dbb803b9943d0f8b62519f1b79c2484afb5436a24" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/58/54/57f7c5638fecdf232a5b6b767da467b0ff31467d7f86a7364c252acf2321/pkginfo-1.4.1.tar.gz"
    sha256 "bb1a6aeabfc898f5df124e7e00303a5b3ec9a489535f346bfbddb081af93f89e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/27/c7/a45641c83c6e28f4922ba6af3d4ae4d79b41932c2f3d77fed9e0bf878149/requests-2.17.3.tar.gz"
    sha256 "8d29f97ed1541709b57caddb77bb20592411d7ca10ec4f03275f49ee8456e225"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"
    sha256 "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/67/7c/95e5425871bf314e484aea5f8ec65b49ab006944309b496cd53c47646155/tqdm-4.14.0.tar.gz"
    sha256 "284b7cb57c135f41122580df8a818ffffd85449a61365dfb41907d2bf115e88e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/96/d9/40e4e515d3e17ed0adbbde1078e8518f8c4e3628496b56eb8f026a02b9e4/urllib3-1.21.1.tar.gz"
    sha256 "b14486978518ca0901a76ba973d7821047409d7f726f22156b24e83fd71382a5"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "tests/fixtures/twine-1.5.0-py2.py3-none-any.whl"
  end

  test do
    wheel = "twine-1.5.0-py2.py3-none-any.whl"
    cmd = "#{bin}/twine upload -uuser -ppass #{pkgshare}/#{wheel} 2>&1"
    assert_match(/Uploading.*#{wheel}.*HTTPError: 403/m, shell_output(cmd, 1))
  end
end
