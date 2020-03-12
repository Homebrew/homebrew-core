class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/39/c2/384c5c82593345734caa26a559a21d29c6694549af03043e405c854dcda3/twarc-1.7.5.tar.gz"
  sha256 "7fe1bd049f7f72215f4ac08fd3aef8e205232606a5e4af73a59acb3912edc684"

  bottle do
    cellar :any_skip_relocation
    sha256 "49787a98c77423d79d5e555f0032f5b8b2569c8aa06bb1e7763d4a77b2588bf4" => :catalina
    sha256 "31185173cf88175f16fc4b89b346b1e630dcd6e1e976f0b7982069a5aa65b403" => :mojave
    sha256 "5f7f91b443b4d25845e1e4d765a684c81b3109431b61440b463d25b3275f78eb" => :high_sierra
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
