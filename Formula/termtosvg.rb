class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/0.6.0.tar.gz"
  sha256 "09ccefb75a6a4f8be186b6efdc3cf355cf8de7dc2222b9e4d841d54e623dd261"

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-U", "-e", ".[dev]"
    venv.pip_install_and_link buildpath
    bin.install_symlink libexec/"bin/termtosvg"
  end

  test do
    testfile = testpath/"test.svg"
    exec("echo \"termtosvg-test\nexit\" | #{bin}/termtosvg  #{testfile} && grep -q termtosvg-test #{testfile}")
  end
end
