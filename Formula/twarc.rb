class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/e1/f2/2d79badd5fab00826d5fb2a66b0d1923933ef937338edbdbdd01ae3f5181/twarc-1.6.1.tar.gz"
  sha256 "2dc79f58859ceb609a139ae90296b9eff754a2219a0b3faa6cd794d2faf6c18b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f1bf0c3d43af7fcce96b1f8e0a6594cf8927d683c923402667de7272cfc49c" => :mojave
    sha256 "0aea1a36d79ca322e23db21734b89004791fd46349116bc335852f51d3e8fb12" => :high_sierra
    sha256 "54273c2c6e3931455cc8468e4e015b5ade2b20bb60a90cb28ec3ab9b8650ca3d" => :sierra
    sha256 "90c4c6a4250c4c0c73a08e3b7f1d5d96533ccf5ca03ccba0572fbddce95b362b" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
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
