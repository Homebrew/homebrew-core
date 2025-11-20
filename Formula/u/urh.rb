class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/7b/af/be36ae7e9184410c2c6d406a1551d7096f394e238cc5f63cb4ddcfc5f2e5/urh-2.9.8.tar.gz"
  sha256 "864130b19553833827931f48f874045a39a6cee219a310a910bcd2ef02cf96b4"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/jopohl/urh.git", branch: "master"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac9e1a2e9eb4ef1d2a51dd85e54252794f1082f3de02ae077b86bcf7c9c6cc24"
    sha256 cellar: :any,                 arm64_sequoia: "62ea259eba408187297df3dada6609c7e3c132dac3005165d0e641e52220caa0"
    sha256 cellar: :any,                 arm64_sonoma:  "44fca98d4457a4a5798ccc36bc43d3d5bb163f5206d371d7348b20babc8c8aed"
    sha256 cellar: :any,                 sonoma:        "859acfa8aa4edfa004eabc14350f08ab187986d9fb20f1ebb724daf421fcdc83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39c8f2f760344dff758d9ab2dff7334046172ff77d8687327dc949dd9e60898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb7995e05db0dfd4a416f43bc7cc57b6d31638b2b908e3f5d12ab849062a613"
  end

  depends_on "cmake" => :build # for numpy
  depends_on "meson" => :build # for numpy
  depends_on "ninja" => :build # for numpy
  depends_on "pkgconf" => :build
  depends_on "hackrf"
  depends_on "pyqt@5"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for numpy
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  # upstream issue: https://github.com/jopohl/urh/issues/1149
  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    # Need to disable build isolation and install Setuptools since `urh` only
    # has a setup.py which assumes Cython and Setuptools are already installed
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    PYTHON
    system libexec/"bin/python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end
