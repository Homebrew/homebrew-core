class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/c2/3d/9cbaac6d7101f50c408ac428d9e37668916a4a3e22292f38748b230239e0/urh-2.9.3.tar.gz"
  sha256 "037b91bb87a113ac03d0695e0c2b5cce35d0886469b3ef46ba52d2342c8cfd8c"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "66d94ec0ed8cac4074e9e8783deec8088569069bfa7b8b2b7d7c9cfddb430c08"
    sha256 cellar: :any,                 arm64_monterey: "79b14cc0d9925d93224017e10e0719da2e8bb113e99589729fb661667ad49a5c"
    sha256 cellar: :any,                 arm64_big_sur:  "d50fd4c34ab6b56e28a89006ba3f27e030c1107e3dffe56f34236427721c6f4f"
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
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
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
