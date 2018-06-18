class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/58/ad/473e532a9dff92faf0027fbfaa4ac36abe7dc65c3efcd7cc73e4b89007c1/urh-2.1.1.tar.gz"
  sha256 "fd66d3f3c054eb9ebef62425cc5289627b93b19e3d9cd155ed02866660c06228"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "afb62d75f88099a2a0e816319ecf3c249af1808be2af5d5c18b83f5d0b81bb9a" => :high_sierra
    sha256 "11f3649ee9a18113b7ea0fa0cdcafb79468b0b338d2236091f75b7c586875513" => :sierra
    sha256 "109078a0659d7d8eb51f26b68f7da7acc9e87ac04066f5d4dadbae163191d2a8" => :el_capitan
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on "numpy"
  depends_on "python"
  depends_on "pyqt"
  depends_on "zeromq"

  depends_on "hackrf" => :optional

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"
    sha256 "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/9f/f6/85a33a25128a4a812c3482547e3d458eebdb19ee0b4699f9199cdb2ad731/pyzmq-17.0.0.tar.gz"
    sha256 "0145ae59139b41f65e047a3a9ed11bbc36e37d5e96c64382fcdff911c4d8c3f0"
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
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system "python3", "test.py"
  end
end
