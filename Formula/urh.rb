class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/1c/20/45c108e7c89db910d68b8cccd988603789b1886acb94f79a716b89dffa19/urh-2.9.4.tar.gz"
  sha256 "da5ee5acf9af62a8261e35cf2f2e40c37dc0898f0d84a3efd5f4ea21e5fb9ced"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f11a16384870bcfb788b151fe6a5971083100cd6351cdfab7a363fd7347e184"
    sha256 cellar: :any,                 arm64_monterey: "2b6e639d82196f76d76781d2122419986c9e643dcb4eded2e3432d5ee00fcf74"
    sha256 cellar: :any,                 arm64_big_sur:  "7b1121f0d2d9780940c50cdf50482b13fe96ae7f6cab38462569ed19094c1b0e"
    sha256 cellar: :any,                 ventura:        "94e865b02d6809295da8755a8186051648e7bafa15cac1b5a26aad83317d9bdc"
    sha256 cellar: :any,                 monterey:       "2ec3e3b3e9978326034a42efdb988b6cfdf4c4253ea26eb49a6c9d21787f2bf3"
    sha256 cellar: :any,                 big_sur:        "48352e9abdfa048dbcc5b0cb39aef14fd40d5d4fdcbadc7b40db3e95c0606be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c5389cf8319dbc575ef300f37c57f982dddc2e77f7563010b3de395eae935d"
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
