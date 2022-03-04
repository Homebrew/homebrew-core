class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/06/d8/f140e9c0f592134580819b959121b47bce042694168032bf8b219d39c977/urh-2.9.2.tar.gz"
  sha256 "e4fac51af73a69eeca25d9a12b777677b3b983de8537a2025ba698e20e6a56af"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f932d73089bd4efbec62d2d043c6a971518a9f92a6f54640862b4bf06a5d2d7a"
    sha256 cellar: :any, arm64_big_sur:  "09dc76c4ab1a6fade85309ced90029fadec5e323768c4bf373f016b25c5aef73"
    sha256 cellar: :any, monterey:       "209aea192ab624cfa0e0be32046c9435db860fae1066abe8d023daa37dd68324"
    sha256 cellar: :any, big_sur:        "9e250394aeddc6784c732b991f583ad6cdac03888c3f3e7ff477c8cfda2a7856"
    sha256 cellar: :any, catalina:       "6a0dd1e02d615789893fbf96ef3d1bc127dd927033fbfc0d6a42945c55d22070"
    sha256 cellar: :any, mojave:         "8c61a1fb6e05c52a17c4bd2d5b22fe2b3de41e4fb8cf4199de4eceef2bd661dc"
  end

  depends_on "pkg-config" => :build
  depends_on "cython"
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system Formula["python@3.9"].opt_bin/"python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end
