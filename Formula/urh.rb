class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/3e/c0/e22a65b02a92fe74686553b1d630f20c337565c1ecb86d910d8b6f4a0ba7/urh-1.6.2.0.tar.gz"
  sha256 "f8a9ee11fe93f24b794f3a1dc1b1cda36d3674c43785bbba469c60249eb8ea37"
  revision 1
  head "https://github.com/jopohl/urh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed510d39d144cb726d834affbd46fb72874953f371281f25ea4b7b8f4cb54203" => :sierra
    sha256 "b592b3417536946a707c5dafdb638c434c7c94a81662c78d315c0b40a7f1dde2" => :el_capitan
    sha256 "9f7374233746e611320d62df04fadca493246ea29b9e42652494e1140d2ebc00" => :yosemite
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on :python3
  depends_on "pyqt"
  depends_on "numpy" => ["with-python3"]

  depends_on "hackrf" => :optional

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b8/47/c85fbcd23f40892db6ecc88782beb6ee66d22008c2f9821d777cb1984240/psutil-5.2.1.tar.gz"
    sha256 "fe0ea53b302f68fca1c2a3bac289e11344456786141b73391ed4022b412d5455"
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
