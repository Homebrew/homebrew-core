class Tuir < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://gitlab.com/ajak/tuir"
  url "https://gitlab.com/ajak/tuir/-/archive/master/tuir-master.tar.gz"
  version "1.28.1"
  sha256 "975d8cca39797eb604023d916370d2195fde363f397101a00f2927888be9eea5"

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
      "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "tuir 1.28.1\n", shell_output("#{bin}/tuir --version")
  end
end
