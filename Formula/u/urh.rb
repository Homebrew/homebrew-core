class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/dd/75/e3ce1cd756dc47ab42166d1ecfb9a9f5e34e2fcf78aeed0b9392313dc057/urh-2.10.0.tar.gz"
  sha256 "c9e2932bc0c7b155cfd9483c058b78d08b51c49cd041ab75a0f4a70fc6cce757"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d045c9c12bfa3c15c40058b62984619e91fc1e7883b39ff2693e140e806f71fc"
    sha256 cellar: :any,                 arm64_sequoia: "21043800855ce2da2456d600a7710040f1af40e620f6e7269890cd9ce16e0b0f"
    sha256 cellar: :any,                 arm64_sonoma:  "ac8bf70afb6a48022aa28d9cdc411b6be8d1d7b1bc6e632b25ade589f495f568"
    sha256 cellar: :any,                 sonoma:        "cb5dc00b8b7b0a563fc01e313b2a42aab04446fb17a02577d115a725ed336e12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "519ef56378fa53f474781233ceb35cd6fc46b21c9be649aed61089846c3b1ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c1c8a80f51c56feeed46ceeb671839ef925ddafffefc669ce3a67fc0c5947f"
  end

  depends_on "pkgconf" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "numpy"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/39/e1/c0d92b1258722e1bc62a12e630c33f1f842fdab53fd8cd5de2f75c6449a9/cython-3.2.3.tar.gz"
    sha256 "f13832412d633376ffc08d751cc18ed0d7d00a398a4065e2871db505258748a6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
