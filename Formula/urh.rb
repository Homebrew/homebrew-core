class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/2e/5f/5acc316e0c9dc2d985f36db198ea3814dbeebc6068c56d3efe1420b17714/urh-2.8.1.tar.gz"
  sha256 "31b807fd083424b0d846eca6e734f563f565f971d76f2ab637b3322e6d09404f"
  revision 1
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "116fedda97ddfa84af56562ae1d001e6eb7e94219ac978dfacb5162a65e5aa52" => :catalina
    sha256 "3d956092640037f5c4bf2be1438018bb996ab0c6ee1a1edff178122dbece4034" => :mojave
    sha256 "d6faaab5d831c2c8d557cbf5e0dc0ec794869b6eb0e60b098e381711047466da" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python"
  depends_on "zeromq"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/9c/9b/706dac7338c2860cd063a28cdbf5e9670995eaea408abbf2e88ba070d90d/Cython-0.29.14.tar.gz"
    sha256 "e4d6bb8703d0319eb04b7319b12ea41580df44fd84d83ccda13ea463c6801414"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/5f/dc/edf6758183afc7591a16bd4b8a44d8eea80aca1327ea60161dd3bad9ad22/psutil-5.6.6.tar.gz"
    sha256 "ad21281f7bd6c57578dd53913d2d44218e9e29fd25128d10ff7819ef16fa46e7"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/3c/83/7ecbe9b762829f589fa9734026e0ccb63cb128fe5615ae1698f65df72bfe/pyzmq-18.1.1.tar.gz"
    sha256 "8c69a6cbfa94da29a34f6b16193e7c15f5d3220cb772d6d17425ff3faa063a6d"
  end

  def install
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
