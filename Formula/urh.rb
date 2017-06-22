class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/66/2f/1cf04ec59830834c498956ddec163a5a87d1e6455133ff04df2d73c030b8/urh-1.6.6.tar.gz"
  sha256 "67ab5eed2c26bd3a1baab228b730cc7bcc3df080b8aac53180303fa965a559c6"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "3711957858fd363c40bb3efb89c99c386e8cbba647bb28648b22539ed3d0ba68" => :sierra
    sha256 "7555f514469bd14f20d2d4af930fc0f194e51a05a601d2d82ef7b6c0a8d2c1f9" => :el_capitan
    sha256 "4f896c9edb0c2d3e66a13798403677aade35cb32fbc6555c17f3be0b363f1b9e" => :yosemite
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on :python3
  depends_on "pyqt"

  depends_on "hackrf" => :optional

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/05/84/0feb999c05f252af50a5fbc463268044feda92cdaad8cb0d0a6073d76057/numpy-1.13.0.zip"
    sha256 "dcff367b725586830ff0e20b805c7654c876c2d4585c0834a6049502b9d6cf7e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/57/93/47a2e3befaf194ccc3d05ffbcba2cdcdd22a231100ef7e4cf63f085c900b/psutil-5.2.2.tar.gz"
    sha256 "44746540c0fab5b95401520d29eb9ffe84b3b4a235bd1d1971cbe36e1f38dd13"
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
