class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://github.com/pypa/twine/archive/1.9.0.tar.gz"
  sha256 "6bac3ab30ba277b8f953b1c7b3c5ce7e7b8eb079d4fcb72a4805ef963e0a0a3d"
  head "https://github.com/pypa/twine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "066bdae89f90d41fc81f1f08668e29b4df5badac4ece00680e37fc7c211beec0" => :sierra
    sha256 "9375c66ab1b4ce0f96d1ad64d1690d4f255572d11463ef1649aae0118b3f86ff" => :el_capitan
    sha256 "f55f7b3174f25b4c5152feded1417b2f45f59b622f13a1891d4345ca218d20b8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  # setup requires
  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/58/54/57f7c5638fecdf232a5b6b767da467b0ff31467d7f86a7364c252acf2321/pkginfo-1.4.1.tar.gz"
    sha256 "bb1a6aeabfc898f5df124e7e00303a5b3ec9a489535f346bfbddb081af93f89e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/72/46/4abc3f5aaf7bf16a52206bb0c68677a26c216c1e6625c78c5aef695b5359/requests-2.14.2.tar.gz"
    sha256 "a274abba399a23e8713ffd2b5706535ae280ebe2b8069ee6a941cb089440d153"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"
    sha256 "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/46/b0/615b394ac0b25f1f1ef229e223c335558d69db97301c93e932fb7e5e4679/tqdm-4.11.2.tar.gz"
    sha256 "14baa7a9ea7723d46f60de5f8c6f20e840baa7e3e193bf0d9ec5fe9103a15254"
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
