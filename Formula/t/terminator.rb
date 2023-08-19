class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ba499365147f501ab12e495af14d5099aee0b378454b4764bd2e3bb6052b6394"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2307bdb153aa6a5fc0e05cdac0b3b71e7c6e4277c293bf65c722b60e5319ad5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b5e90f5d1fc261e196e25196d73be1c936d1f91ab2c4a19b8db4f62925d2c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a9e3d8693c6bd2d93d3aa7b56e958e53d4fb2d0c0bbe457f91e6394df2438d8"
    sha256 cellar: :any_skip_relocation, ventura:        "9827d8d873ac411d20b41aaf7610c1f2e9d7b2526620f7df2bc9be2b5da8af05"
    sha256 cellar: :any_skip_relocation, monterey:       "311ad497c491d2e0667c16671c6a95ab683b47b1946422d51aee6d131f69b67e"
    sha256 cellar: :any_skip_relocation, big_sur:        "85457c6098ae589d2b16d6aa4cbed08df9ce4c364503ff4a5c8385d9e8da616d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc1c9a39ed76ef6d67b3831a687776f880afd77609982e37cc7459b334a2190"
  end

  depends_on "pygobject3"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
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
