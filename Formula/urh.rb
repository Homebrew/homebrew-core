class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/0a/f7/6a6d5666c01a4d7817198b8051b1215b0e2f03c19f7dff06a0a773bb07c1/urh-1.9.1.tar.gz"
  sha256 "78b09c44eaa1a175cc25677a916c6390f896f1b78adcc7528991651655182fca"
  revision 1
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "0ba579f1d404e0880b165c71dbe620929b037a70e6d97c5072e76f9e2651e33b" => :high_sierra
    sha256 "7e97d3f11a7d586c7913ef9bbdbdae70b17f35e5fe5d1ce4e4b634c9a5690d34" => :sierra
    sha256 "b62f975582f2baf62ee8d0bd0cdae3ac9ca03aba64feae269769fae99b80dd4f" => :el_capitan
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on "python3"
  depends_on "pyqt"

  depends_on "hackrf" => :optional

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/bf/2d/005e45738ab07a26e621c9c12dc97381f372e06678adf7dc3356a69b5960/numpy-1.13.3.zip"
    sha256 "36ee86d5adbabc4fa2643a073f93d5504bdfed37a149a3a49f4dde259f35a750"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/54/24/aa854703715fa161110daa001afce75d21d1840e9ab5eb28708d6a5058b0/psutil-5.4.2.tar.gz"
    sha256 "00a1f9ff8d1e035fba7bfdd6977fa8ea7937afdb4477339e5df3dba78194fe11"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/1e/f9/d0675409c11d11e549e3da000901cfaabd848da117390ee00030e14bfdb6/pyzmq-16.0.3.tar.gz"
    sha256 "8a883824147523c0fe76d247dd58994c1c28ef07f1cc5dde595a4fd1c28f2580"
  end

  def install
    # Workaround for https://github.com/Homebrew/brew/issues/932
    ENV.delete "PYTHONPATH"
    # suppress urh warning about needing to recompile the c++ extensions
    inreplace "src/urh/main.py", "GENERATE_UI = True", "GENERATE_UI = False"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1]
      assert(expected == c.crc([1, 2, 3]).tolist())
    EOS
    system "python3", "test.py"
  end
end
