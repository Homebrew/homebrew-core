class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/39/c2/384c5c82593345734caa26a559a21d29c6694549af03043e405c854dcda3/twarc-1.7.5.tar.gz"
  sha256 "7fe1bd049f7f72215f4ac08fd3aef8e205232606a5e4af73a59acb3912edc684"

  bottle do
    cellar :any_skip_relocation
    sha256 "9337719eeb53a8e84dbbd3c09af25c32ed24d2fa9934868986b8dcf2feb58e49" => :catalina
    sha256 "3f247f84bdfefa5856eea5a7e8e81f0acd1456bf68ab87fd0f2afb612a940c22" => :mojave
    sha256 "afe2c1fb2379f1d32c6e004823310908850394ed1af33f622afd6165b4914c5e" => :high_sierra
    sha256 "fd651808b565af0bbd66744e1452ce6675c851cc6940b5ce3a4dca894e594fce" => :sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
