class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/c2/3d/9cbaac6d7101f50c408ac428d9e37668916a4a3e22292f38748b230239e0/urh-2.9.3.tar.gz"
  sha256 "037b91bb87a113ac03d0695e0c2b5cce35d0886469b3ef46ba52d2342c8cfd8c"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/jopohl/urh.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d88fd08049e3eb1fb74ad3adaca2e00a3a7f6bd38ce54cbd38a4ae5bc611f362"
    sha256 cellar: :any,                 arm64_big_sur:  "9424a7749801f6715bd090550243c8648476fd7a9341478601ecc97733479694"
    sha256 cellar: :any,                 monterey:       "de9494a90a16e95c9b56c8a8c6754a4bca1ec8877b80c4ea8fd74cbfa6c155ed"
    sha256 cellar: :any,                 big_sur:        "e9d8335313cd3438bb1f3f3cc15876e25550f6b9e9a06c190f53bd28c24f9e19"
    sha256 cellar: :any,                 catalina:       "8251c7319b097610a58503876afe9b72b6af903cd89e9f06cac863f4ca318c59"
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
    site_packages = Language::Python.site_packages("python3")
    ENV.prepend_create_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
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
