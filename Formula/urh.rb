class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/c2/3d/9cbaac6d7101f50c408ac428d9e37668916a4a3e22292f38748b230239e0/urh-2.9.3.tar.gz"
  sha256 "037b91bb87a113ac03d0695e0c2b5cce35d0886469b3ef46ba52d2342c8cfd8c"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c5acb232a2004f08f20d9369b6cd32f5a65b1395106e5b1a231212241195bc4d"
    sha256 cellar: :any,                 arm64_big_sur:  "d0e14502e070b7c0133c58435fc4a1f6ba8b0128e0b5dbf19ed0c3a9a9678847"
    sha256 cellar: :any,                 monterey:       "4577d99a40fd2bd4ce977d609cec2df9be42ad4c8927f0d62b0ddf312c6f6e47"
    sha256 cellar: :any,                 big_sur:        "dd663c9c07deab9e895f2c36af4e14bf10f8595b7f03796cd1de115ee9fec2ce"
    sha256 cellar: :any,                 catalina:       "7f186f12b566ba25bb43960694891bd9f4907ec3b44499a75ce4c7cae7355717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c1d3a4d3e6b5175e8034b37147c43f38d0839e9ea6fea7719b34dcde5f7cd2"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "libcython"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.9"

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
