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
    sha256 cellar: :any,                 arm64_monterey: "7d862994902ccc7634d09ebd4a6194f5e893fbaa00ad843b13dfe49626a8ee09"
    sha256 cellar: :any,                 arm64_big_sur:  "fe3a55526c47c81f8ddf1b2f97ef9e904c55b4925e28e1584fe91afb6f57c370"
    sha256 cellar: :any,                 monterey:       "48efdeda0d8a26c00167a373ce77ab7453c29b5c0c084a89274904bff4d29208"
    sha256 cellar: :any,                 big_sur:        "b0b45ccf33181e64d4fd9e6015b91a89fe982d88b0e52ce77a6762afad796d42"
    sha256 cellar: :any,                 catalina:       "437efab97a5e4c0f3a58f2558255753ee10650b8dc4909c91eb48d5c3ee5fac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0a6260a67f91ae789d1aff64263ad53665558bc766356726bd0a4817f21c5a"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "libcython"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.10"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    python3 = "python3.10"

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
