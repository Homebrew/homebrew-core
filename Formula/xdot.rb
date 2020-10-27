class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/0f/1b/7ae17e0931ff011bba1c86000674666176021756d07ed29ce0b263b3fddf/xdot-1.1.tar.gz"
  sha256 "e15c53d80dc8777402a7258eebe6cbf395d04085ff9699bbffae91df0ecc2433"
  license "LGPL-3.0"
  revision 2
  head "https://github.com/jrfonseca/xdot.py.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "02b39229746925ce78c56e1e1c0949281e92f2cc1e51db8b3d3144ae9d7d9ce1" => :catalina
    sha256 "3e4a93d80f24c101c14eb914a00f1c82abc6116b366d7af1d914729e43d04eb6" => :mojave
    sha256 "07771ec705b09984c6748e4bd691527602b530172efdf845b92a3e9fa2d65e19" => :high_sierra
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/9a/00/481ad02701f952c59671a574a808d9d34d200103f0c7396db75f2e3df717/graphviz-0.11.1.zip"
    sha256 "914b8b124942d82e3e1dcef499c9fe77c10acd3d18a1cfeeb2b9de05f6d24805"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("graphviz").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
