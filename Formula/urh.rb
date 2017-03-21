class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/29/47/f00588ff9d6807c7f8b54e1c7cf6fe8f66fd1f4ddaa85f03d7f2eff6719c/urh-1.6.1.8.tar.gz"
  sha256 "7baca3e51484946644584509966d827943b3abd42fd82dcaf0d3e3c2acabaf8f"
  head "https://github.com/jopohl/urh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c05000a9a37bd2b2c0db09855562a6dcd53405e868ed03ebb19a65ab1c80533d" => :sierra
    sha256 "a95cdc8b6844d4d7d38e170f9746a45a150b56247f4ed00bd351e9d1620130d2" => :el_capitan
    sha256 "965797575cd63983be12b5e8f5ff04ca8c3b9d131e8feb698b7b94a1720ad99d" => :yosemite
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on :python3
  depends_on "pyqt5"
  depends_on "numpy" => ["with-python3"]

  depends_on "hackrf" => :optional

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3c/2f/f3ab91349c666f009077157b12057e613a3152a46a6c3be883777546b6de/psutil-5.2.0.tar.gz"
    sha256 "2fc91d068faa5613c093335f0e758673ef8c722ad4bfa4aded64c13ae69089eb"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/af/37/8e0bf3800823bc247c36715a52e924e8f8fd5d1432f04b44b8cd7a5d7e55/pyzmq-16.0.2.tar.gz"
    sha256 "0322543fff5ab6f87d11a8a099c4c07dd8a1719040084b6ce9162bcdf5c45c9d"
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
    system "python3", "-c", "import urh.util.crc;c = urh.util.crc.crc_generic();assert(c.crc([1, 2, 3]) == [True, False, False, False, False, False, True, True, False, False, False, False, False, False, True, True])"
  end
end
