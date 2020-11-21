class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/8b/f5/f5282a470a1c0f16b6600edae18ffdc3715cdd6ac8753205df034650cebe/xdot-1.2.tar.gz"
  sha256 "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70"
  license "LGPL-3.0"
  head "https://github.com/jrfonseca/xdot.py.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "100ca9fc3606b95071092b394f10bd5cd1a4dbed885dc7697b81d514f56c2629" => :big_sur
    sha256 "02b39229746925ce78c56e1e1c0949281e92f2cc1e51db8b3d3144ae9d7d9ce1" => :catalina
    sha256 "3e4a93d80f24c101c14eb914a00f1c82abc6116b366d7af1d914729e43d04eb6" => :mojave
    sha256 "07771ec705b09984c6748e4bd691527602b530172efdf845b92a3e9fa2d65e19" => :high_sierra
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/33/c4/82459071796f59ef218d3c22d43d35aa0fbcf74f9fcce8829672febd7f5e/graphviz-0.15.zip"
    sha256 "2b85f105024e229ec330fe5067abbe9aa0d7708921a585ecc2bf56000bf5e027"
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
