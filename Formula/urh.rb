class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/09/84/0e597e6e17ac6cf11e72ebdbb574857f12f8ae7799a193cc4955105a0a77/urh-1.8.6.tar.gz"
  sha256 "4afed92ee116333277f1a6e0e5b99c9bcb0c7ef03d34edd405f640047c6f4720"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "94d64e2036b047b82d51747780f3c30e400c7aff2d9b93efa8812c9dea64e0c3" => :sierra
    sha256 "28c1201416dd06966ec0d2de9df1cc739c4af401d769003cffbc70ddbf29f5f0" => :el_capitan
    sha256 "b2196ff1629c399920693a7b69eb7fdb422a53bc67befbd1702e1a201ae3a1e9" => :yosemite
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on :python3
  depends_on "pyqt"

  depends_on "hackrf" => :optional

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/c0/3a/40967d9f5675fbb097ffec170f59c2ba19fc96373e73ad47c2cae9a30aed/numpy-1.13.1.zip"
    sha256 "c9b0283776085cb2804efff73e9955ca279ba4edafd58d3ead70b61d209c4fbb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1c/da/555e3ad3cad30f30bcf0d539cdeae5c8e7ef9e2a6078af645c70aa81e418/psutil-5.3.0.tar.gz"
    sha256 "a3940e06e92c84ab6e82b95dad056241beea93c3c9b1d07ddf96485079855185"
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
    (testpath/"test.py").write <<-EOS.undent
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1]
      assert(expected == c.crc([1, 2, 3]).tolist())
    EOS
    system "python3", "test.py"
  end
end
