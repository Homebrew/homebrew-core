class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/0a/bd/de6cbf2ee609b0873fab4b32b265d4f02f413f82ef26aa73eef7e153d92c/urh-1.8.17.tar.gz"
  sha256 "bba27515ae00bbc349fc1926c8bbcc55f3f6f572a075ac09933b3d7ae8ffff9a"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "7e923859f57139f53e830a68bbf8fc32df4880a1248611af695b340cd3ba4746" => :high_sierra
    sha256 "61d6557978916046f42be67ffe3519c66f384847c61efa03e2828cdd2a297722" => :sierra
    sha256 "c4b67de79c62cb397f91761271771b811da2a3112a8c1779d73b482bc613d9cb" => :el_capitan
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on :python3
  depends_on "pyqt"

  depends_on "hackrf" => :optional

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/bf/2d/005e45738ab07a26e621c9c12dc97381f372e06678adf7dc3356a69b5960/numpy-1.13.3.zip"
    sha256 "36ee86d5adbabc4fa2643a073f93d5504bdfed37a149a3a49f4dde259f35a750"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/17/0f0bf5792b2dfe6003efc5175c76225f7d3426f88e2bf8d360cfab870cd8/psutil-5.4.1.tar.gz"
    sha256 "42e2de159e3c987435cb3b47d6f37035db190a1499f3af714ba7af5c379b6ba2"
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
