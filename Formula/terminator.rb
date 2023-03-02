class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ba499365147f501ab12e495af14d5099aee0b378454b4764bd2e3bb6052b6394"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "553547ec5d0f5f0704c279cdd9f1df9ba027f9eb704ed52877865f2e6f064d22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada81984b24711c6cfdd4e31dd4015582bf81eec755423ae29d7ae9bc8365f0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8d4d53151ad1204d1af781c284a4353a30910ccdaab57f8dff08fb70a5c9dc4"
    sha256 cellar: :any_skip_relocation, ventura:        "10d1ddcb032ee692a31e415b988a37c79b9bba7a897768ef17311ec83073720a"
    sha256 cellar: :any_skip_relocation, monterey:       "9983a9baec039953cf6c2c91cbe363a63e276e77bb84723e7634fb040417779a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8e88d9fba374decf7b2629a4369c9a23e358e2b48752f6ff7f099d9770be673"
    sha256 cellar: :any_skip_relocation, catalina:       "c1fce0d5da33ab49ff3594ecbbeaff1f5f3f14b91d85f1c773df4f6f19fafaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68406abd3adba8d745c09e2ab5869e21785c3e16237078f0e3ae98da2f8580e8"
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
