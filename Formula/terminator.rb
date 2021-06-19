class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "ee1907bc9bfe03244f6d8074b214ef1638a964b38e21ca2ad4cca993d0c1d31e"
  license "GPL-2.0-only"

  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "six"
  depends_on "vte3"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
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
    sleep 5
    Process.kill "TERM", pid
    assert_match "Window::create_layout: Making a child of type: Terminal", File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end
