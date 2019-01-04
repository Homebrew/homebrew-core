class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/81/29/8ffecf5a0d99bef5a4463fd9dbea537e119562737aaac10b1997da135d5d/urh-2.2.3.tar.gz"
  sha256 "9867398e94b1c05a227fa2a5765cfbf7fda6327600a2e50f612988063d05ee1d"
  revision 3
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "fec9b7d41d20bd4ba98e28ffb78c9113cfaf31fd592f478aa98c8d4082b53371" => :mojave
    sha256 "aaacecdabc58fdd199c2259935010d065d10bb913d659747168758ca02eddfaf" => :high_sierra
    sha256 "6af1143085602e2abe23491d08b5ab85482c09b3f40d07f97926499b3b73f2ab" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python"
  depends_on "zeromq"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/d2/12/8ef44cede251b93322e8503fd6e1b25a0249fa498bebec191a5a06adbe51/Cython-0.28.4.tar.gz"
    sha256 "76ac2b08d3d956d77b574bb43cbf1d37bd58b9d50c04ba281303e695854ebc46"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"
    sha256 "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/aa/fd/f2e65a05558ff8b58b71404efc79c2b03cef922667260e1d703896597b93/pyzmq-17.1.0.tar.gz"
    sha256 "2199f753a230e26aec5238b0518b036780708a4c887d4944519681a920b9dee4"
  end

  def install
    # Workaround for https://github.com/Homebrew/brew/issues/932
    ENV.delete "PYTHONPATH"
    # suppress urh warning about needing to recompile the c++ extensions
    inreplace "src/urh/main.py", "GENERATE_UI = True", "GENERATE_UI = False"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      next if r.name == "Cython"
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    saved_python_path = ENV["PYTHONPATH"]
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{xy}/site-packages"

    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"cython")
    end

    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => saved_python_path)
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
