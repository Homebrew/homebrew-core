class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https://tmt.readthedocs.io"
  url "https://github.com/teemtee/tmt/archive/refs/tags/1.31.0.tar.gz"
  sha256 "5640ac6e5bc5c0ed47fe36663fdb8b238d806c9be3be649bb3953e3a65301790"
  license "MIT"

  depends_on "python-hatchling" => :build
  depends_on "beakerlib"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "fmf" do
    # No PyPI source, use git repo instead
    # https://github.com/teemtee/fmf/issues/224
    url "https://github.com/teemtee/fmf/archive/refs/tags/1.3.0.tar.gz"
    sha256 "85f84f591d9e577742f9d3d6ee6a05f7b03ae6ee8de4c60d2083c015e61f3699"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/eb/59/73fd3810d94f2c87aacc79f4e578e1d81df6f0f2800b80b7d3c4fb4e3a2d/Pint-0.19.2.tar.gz"
    sha256 "e1d4989ff510b378dad64f91711e7bdabe5ca78d75b06a18569ac454678c4baf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    # Temporary hack because tmt does not include .git_archival.txt
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/tmt --version 2>&1")
  end
end
