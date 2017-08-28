class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/bf/70/7d48786e49c89c171f15c44a91172185248195c48257e903e9149b3d37bd/urh-1.8.4.tar.gz"
  sha256 "47c4cb79015e111b97fa4b3770ae705a180e187ec9c96500945fcb617a9c2a32"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "16a805ba2254981a778c813e060ae3974a0b6ddb713be0471459cec01b345bf8" => :sierra
    sha256 "2efe04f55a858960811800d6113039e23f13a747c50ddb2b603c5845cc5e6989" => :el_capitan
    sha256 "09cbce63e05b7f6e7da2e6b6658192b86a6e7811e0523fd6f4908c0d53117800" => :yosemite
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
    (testpath/"test.py").write <<-EOS.undent
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1]
      assert(expected == c.crc([1, 2, 3]).tolist())
    EOS
    system "python3", "test.py"
  end
end
