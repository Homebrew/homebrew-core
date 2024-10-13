class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/d8/dc/a6dcf5686e980530b23bc16936cd9c879c50da133f319f729da6d20bd95b/urh-2.9.6.tar.gz"
  sha256 "0dee42619009361e8f5f54d48f31e1c6cf24b171c773dd38f99a34111a0945e1"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f4c830b4dcadd93a8cb54abe61279a9d4c6498b519422fe51da78cafbf036e0d"
    sha256 cellar: :any,                 arm64_sonoma:   "9cf0c985be519cb7a5f1451f28e242d9505aecd69e45f24e6ea5ee5348c13421"
    sha256 cellar: :any,                 arm64_ventura:  "eb11c4f95f491213e504f5b60504b12a828caa585be5c0aec76feeca62f57ab5"
    sha256 cellar: :any,                 arm64_monterey: "750206ac26d982f439f424f847ba0836fe8a5dcc38ee6d11365bd4c13515c371"
    sha256 cellar: :any,                 sonoma:         "c0a2928d954e4db4233ec61cd01b51dd53a97ce5378064645da014ba0809cc2a"
    sha256 cellar: :any,                 ventura:        "add9e8fa22725e8821e914840d7d9fb7d7264a759aa938ad71e79518f753eeee"
    sha256 cellar: :any,                 monterey:       "d7ecf3dccb8741f280378988e79477a37b78eb6493f50cf4688582f24c697abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7249ef337f50461015896cc171db6501f3ca2b3d0b9e0664a2c32ba51fb7629"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.12"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/2a/97/8cc3fe7c6de4796921236a64d00ca8a95565772e57f0d3caae68d880b592/Cython-0.29.37.tar.gz"
    sha256 "f813d4a6dd94adee5d4ff266191d1d95bf6d4164a4facc535422c021b2504cfb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    # Need to disable build isolation and install Setuptools since `urh` only
    # has a setup.py which assumes Cython and Setuptools are already installed
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system libexec/"bin/python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end
