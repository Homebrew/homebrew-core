class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/f5/43/e56150c5f6d02d627e68098706a0a1610ae41094804f8b8c1242fdd5e0a9/urh-2.1.0.tar.gz"
  sha256 "7ace3c2f967a25f73f4e0477307cb4c5ae765759a404a776dded99ddee1bce17"
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "6ea96f780ec1d09f58c76cd5cbdab0b442638f726ccb69b7d77e206d53c54c3b" => :high_sierra
    sha256 "85d9ad5f3d4e138829804f601cbbe51917ae615bd3c112e1fb0a55daaab79c9d" => :sierra
    sha256 "9fa73b4c701f0f8c36af0c19c7dcaa31764a67e4742f4ccfbad69312d90c51e2" => :el_capitan
  end

  option "with-hackrf", "Build with libhackrf support"

  depends_on "pkg-config" => :build

  depends_on "numpy"
  depends_on "python"
  depends_on "pyqt"
  depends_on "zeromq"

  depends_on "hackrf" => :optional

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/14/a2/8ac7dda36eac03950ec2668ab1b466314403031c83a95c5efc81d2acf163/psutil-5.4.5.tar.gz"
    sha256 "ebe293be36bb24b95cdefc5131635496e88b17fabbcf1e4bc9b5c01f5e489cfe"
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
