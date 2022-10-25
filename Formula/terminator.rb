class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "8239dfa28a51b288c463459a937225d3f657cde926f4db481be49f1691bd5083"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a19c6a8ba41802e184b380a2b45d3fa51e0030012639769786443d491d980922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776a2436154ebd9c70182bdaa0d925574b14d2813dc40ae7cca4f06ff74b6526"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2444b4441dd5c6f815d9c728f342457475409c8a122c11085f42da1c69f6b444"
    sha256 cellar: :any_skip_relocation, monterey:       "aafa29fcd069edba6d0e019a8f334d3ad572555e8d65f47da01236ed98249b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "6060df119de704db1e6b7f9a11a64a954991450ae54e3514ecf56e7c250d220c"
    sha256 cellar: :any_skip_relocation, catalina:       "64ce7c125a245ceae49f80077ca9ae45068743dc17be8fdd2c6d068a83e49d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63da3e0a44a01a16ce19c045b7180a3225cf013a768a03966cb15254f1844821"
  end

  depends_on "pygobject3"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "vte3"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = Process.spawn bin/"terminator", "-d", [:out, :err] => "#{testpath}/output"
    sleep 30
    Process.kill "TERM", pid
    output = if OS.mac?
      "Window::create_layout: Making a child of type: Terminal"
    else
      "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    end
    assert_match output, File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end
