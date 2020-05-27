class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/ef/9c/b023e69e2de551fe2250d2e374a62e41719d6bb491f96c6bc9c689fb1d28/urh-2.8.8.tar.gz"
  sha256 "8c05637f7090958a03b3c67cb824252fa8a3677622f0c9e60aac91f0d0af07ca"
  head "https://github.com/jopohl/urh.git"

  bottle do
    cellar :any
    sha256 "fb22d5e9fed75cbb00c5c22b359de3299f50d49f4baae954dc41d4927dbe5a5a" => :catalina
    sha256 "25b6be81e54e99e4f66ef1cb7a086eb0c10d4e6fdd4133cdf65fda7aff888a31" => :mojave
    sha256 "49e2d8da0dd87063bafa120cff9f32ea86165b1b9504bc4955c27bede697b0d0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.8"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/99/36/a3dc962cc6d08749aa4b9d85af08b6e354d09c5468a3e0edc610f44c856b/Cython-0.29.17.tar.gz"
    sha256 "6361588cb1d82875bcfbad83d7dd66c442099759f895cf547995f00601f9caf2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41/psutil-5.7.0.tar.gz"
    sha256 "685ec16ca14d079455892f25bd124df26ff9137664af445563c1bd36629b5e0e"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      next if r.name == "Cython"

      r.stage do
        system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    saved_python_path = ENV["PYTHONPATH"]
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{xy}/site-packages"

    resource("Cython").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"cython")
    end

    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => saved_python_path)
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system Formula["python@3.8"].opt_bin/"python3", "test.py"
  end
end
