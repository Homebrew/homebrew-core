class Touca < Formula
  include Language::Python::Virtualenv

  desc "Open source tool for regression testing complex software workflows"
  homepage "https://github.com/trytouca/trytouca/tree/main/sdk/python"
  url "https://files.pythonhosted.org/packages/c8/6d/e1986d8c9b4f6cd2b583d0df8bd1769989b5ce5cb91dcc613b0d187e4a7a/touca-1.8.7.tar.gz"
  sha256 "244a52be4cf4670077fda0b740ac067470745da7084c241bc619b332f771d940"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "2aef71401d6fa95a1c2a1d9ce7ccf63c49e0131602a7876914ddbb373246b6f3"
  end

  deprecate! date: "2025-08-13", because: :unmaintained

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/0c/6e/3e52cd294d8e7a61e010973cce076a0cb2c6c0dfd4d0b7a13648c1b98329/flatbuffers-23.5.26.tar.gz"
    sha256 "9ea1144cac05ce5d86e2859f431c6cd5e66cd9c78c558317c7955fb8d4c78d89"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "touca-fbs" do
    url "https://files.pythonhosted.org/packages/0e/ae/c5bd348bf8c21d5696538261dc8c05fc5e5a7d60056ecf7180c590d02bd1/touca_fbs-0.0.3.tar.gz"
    sha256 "f9d31d0498bff34637356dcd567ae026e9f10d24ee806bf2e020be49b472779d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  def install
    # Allow latest `certifi`: https://github.com/trytouca/trytouca/pull/663
    inreplace "pyproject.toml", 'certifi = "^2022.12.7"', 'certifi = ">=2022.12.7"'
    # Workaround broken script with poetry 2+
    inreplace "pyproject.toml", 'touca = { callable = "touca.cli.__main__:main" }',
                                'touca = "touca.cli.__main__:main"'
    venv = virtualenv_install_with_resources without: "flatbuffers"

    # Workaround a relative LICENSE file failing with new setuptools validation
    # https://github.com/pypa/setuptools/commit/c31ebdc4749f1439972451a7b9b28734281d3830
    # Backport of https://github.com/google/flatbuffers/commit/6cb4d671a88e054744ce3029df9e733dc724ee76
    resource("flatbuffers").stage do
      inreplace "setup.cfg", "../license", "../LICENSE"
      inreplace "setup.py", "license_files='../LICENSE',", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/touca version")
    assert_empty shell_output("#{bin}/touca profile set test-profile")
    assert_empty shell_output("#{bin}/touca config set some-key=some-value")
    assert_match "some-key", shell_output("#{bin}/touca config show")
    assert_match "some-value", shell_output("#{bin}/touca config show")
    assert_match "test-profile", shell_output("#{bin}/touca profile ls")
    assert_empty shell_output("#{bin}/touca profile rm test-profile")
  end
end
