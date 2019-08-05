class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/0f/1b/7ae17e0931ff011bba1c86000674666176021756d07ed29ce0b263b3fddf/xdot-1.1.tar.gz"
  sha256 "e15c53d80dc8777402a7258eebe6cbf395d04085ff9699bbffae91df0ecc2433"
  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcd8c80b0d21b0d2791515138d38dbce56324daac9ffa64625368c17d63127e9" => :mojave
    sha256 "3d25f865fcd7ea38945d1b5fcdb6edebce950515c727ceee5804f4c90487fb1b" => :high_sierra
    sha256 "ecc75687bb7340438ea568f15197c16bed3bba0ba5c67e8499d22cada987473b" => :sierra
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/9a/00/481ad02701f952c59671a574a808d9d34d200103f0c7396db75f2e3df717/graphviz-0.11.1.zip"
    sha256 "914b8b124942d82e3e1dcef499c9fe77c10acd3d18a1cfeeb2b9de05f6d24805"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("graphviz").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
