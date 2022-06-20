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
    sha256 cellar: :any,                 arm64_monterey: "27f10408a73529f5680540ec0033410e4c336da56f8e50c184e49c101e619652"
    sha256 cellar: :any,                 arm64_big_sur:  "fd5f62efa195ca2c91d6f7cba1cd48204b3a5a2b19d38356b6c1f3bac1d46aa6"
    sha256 cellar: :any,                 monterey:       "c5d037f35ae8edd2fd3e5353c8d1ff69f6786a607fa1c520240e518403a6e2df"
    sha256 cellar: :any,                 big_sur:        "1ef987750b1f35e896ea40e4a4d10933e7999e5d98061bc72b1956713d11b0b9"
    sha256 cellar: :any,                 catalina:       "2b44f853d6ebf463106779c2edd2439d56d16016ad0a71a51d477282557bd9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f0544eb7a11800e0949bfc4045616b47c36822cb4d1f9323c2c6cf02eade80"
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
