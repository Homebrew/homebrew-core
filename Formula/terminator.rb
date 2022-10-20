class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "8239dfa28a51b288c463459a937225d3f657cde926f4db481be49f1691bd5083"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098c77a630f6f02fa66e6eb7a592f3229bd70cb91584ac2de78c75944bd8fa19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c2883a811abc01c06c9386915c6fd3a74f1e0ea62319bc7314d33651165d3f3"
    sha256 cellar: :any_skip_relocation, monterey:       "1c85992e04ffab1a37b0fe92dfbef27e89c2eceb83fda20eaf5c4c57c0147289"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe4124f38acbd8f8a8632e6b56b6f6556a8317343ac3dcc5c41ac45507e3570a"
    sha256 cellar: :any_skip_relocation, catalina:       "6ea19d85c2f874bd47e34fc6b25ecd72e9c64a73c18390a1088ce75bf3633144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b2da44020cf6178179d8fe022202e14cd95b76e4ac0c24d87d49cce361b0ce"
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
