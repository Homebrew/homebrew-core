class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/1c/20/45c108e7c89db910d68b8cccd988603789b1886acb94f79a716b89dffa19/urh-2.9.4.tar.gz"
  sha256 "da5ee5acf9af62a8261e35cf2f2e40c37dc0898f0d84a3efd5f4ea21e5fb9ced"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "66d94ec0ed8cac4074e9e8783deec8088569069bfa7b8b2b7d7c9cfddb430c08"
    sha256 cellar: :any,                 arm64_monterey: "79b14cc0d9925d93224017e10e0719da2e8bb113e99589729fb661667ad49a5c"
    sha256 cellar: :any,                 arm64_big_sur:  "d50fd4c34ab6b56e28a89006ba3f27e030c1107e3dffe56f34236427721c6f4f"
    sha256 cellar: :any,                 ventura:        "4443995daa3830f3da9f458eb34e1af6a14396b8a18a717514f05b1abb1b374d"
    sha256 cellar: :any,                 monterey:       "1ce1473b5c9661fbfe6aaf7acebf3212f1c87c8660c9afcc5674369196f82ab4"
    sha256 cellar: :any,                 big_sur:        "c4bf2f1bda2227932929cdea464da4e67302b5413f4c88d8a34bcc1a02e2c460"
    sha256 cellar: :any,                 catalina:       "9a4c90a206ee271341819db55da4ae14704265fab550cdce5928b4e31e5aa0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36bae1941ae6e9b61c9e63bc3daf2758056a92187f5f394f0244a4688b45128"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "libcython"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  def install
    python3 = "python3.11"

    # Enable finding cython, which is keg-only
    site_packages = Language::Python.site_packages(python3)
    pth_contents = <<~EOS
      import site; site.addsitedir('#{Formula["libcython"].opt_libexec/site_packages}')
    EOS
    (libexec/site_packages/"homebrew-libcython.pth").write pth_contents

    virtualenv_install_with_resources
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
