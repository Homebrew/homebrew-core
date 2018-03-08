class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://github.com/pypa/twine/archive/1.10.0.tar.gz"
  sha256 "74e7640394f1795713883752c83bfa9f5353f64c67e15db7092de051b38cfa37"
  head "https://github.com/pypa/twine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37cd3858e20cb8456053789c75d66767d40d3898dd4ec6725a99ea39220de0a4" => :high_sierra
    sha256 "4d48e4d27b3933ea505f219d84be07f734dbff3e5e7a133ed23a0bcb5288998c" => :sierra
    sha256 "be0b38d0ca616f4c65ca220d238b0e1f64cc8b822350ce0ec804a0e85e57ac16" => :el_capitan
    sha256 "c88b0ffc33039b8cf6027e2dbb803b9943d0f8b62519f1b79c2484afb5436a24" => :yosemite
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

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
    url "https://files.pythonhosted.org/packages/58/54/57f7c5638fecdf232a5b6b767da467b0ff31467d7f86a7364c252acf2321/pkginfo-1.4.1.tar.gz"
    sha256 "bb1a6aeabfc898f5df124e7e00303a5b3ec9a489535f346bfbddb081af93f89e"
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
    url "https://files.pythonhosted.org/packages/48/18/7a36d86aded6533ebd66148872f07e489647be6a431a5bf94be2a9dbd232/tqdm-4.19.6.tar.gz"
    sha256 "5ec0d4442358e55cdb4a0471d04c6c831518fd8837f259db5537d90feab380df"
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
