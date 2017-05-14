class TwinePypi < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https://github.com/pypa/twine"
  url "https://github.com/pypa/twine/archive/1.8.1.tar.gz"
  sha256 "918d7ebab52280bac573af9a6c80622202f0cdeab14cb3360f9ffb9848be946d"
  head "https://github.com/pypa/twine.git"

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
    url "https://files.pythonhosted.org/packages/ab/bf/2af6b25f880e2d529a524f98837d33b1048a2a15703fc4806185b54e9672/requests-toolbelt-0.7.1.tar.gz"
    sha256 "c3843884269d79e492522f3e9f490917e074c1ddbb80111968970e721fe36eaf"
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
