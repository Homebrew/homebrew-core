class Tuir < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://gitlab.com/ajak/tuir"
  url "https://gitlab.com/ajak/tuir/-/archive/v1.28.1/tuir-v1.28.1.tar.gz"
  sha256 "a0ca434873a9f9258cd9b0868190bd4b64350b0eefb3eb90f185f984f02fd1cf"

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
