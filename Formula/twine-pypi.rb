class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://github.com/pypa/twine/archive/1.11.0.tar.gz"
  sha256 "fdff00d235b964a9679fc0c127228eb83fb82b59552efb130cd878ace39f3473"
  head "https://github.com/pypa/twine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b49976575116b9f1cb89118cbc39a53b7821f71e680c1205e09d2e842e60ce" => :mojave
    sha256 "33e7f275476265efae9cdf0be219eacaf24b75d361c5cb3f746ed74a6cefbfd9" => :high_sierra
    sha256 "771fc2f1705f7eabee1886d90f8afad98a671c88756e5e69dbb23c5abd4f91dd" => :sierra
    sha256 "7faeb5be32232e9adaee4f55a50e3f965451ec4b58e18bd472b9c6ffa4669dfe" => :el_capitan
  end

  depends_on "python@2"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/39/c9/111ececbeed8e69cd1b6bec79a32a0b0f6074038a4244e58e285ad278248/pkginfo-1.4.2.tar.gz"
    sha256 "5878d542a4b3f237e359926384f1dde4e099c9f5525d236b1840cf704fa8d474"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"
    sha256 "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a6/74/cb6927443849ec849ad7cdcdc8e38f04d81fce41783150c0d5215ec504a8/tqdm-4.19.8.tar.gz"
    sha256 "2aea9f81fdf127048667e0ba22f5fc10ebc879fb838dc52dcf055242037ec1f7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
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
