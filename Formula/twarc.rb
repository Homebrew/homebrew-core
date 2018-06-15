class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/96/27/410275915d6c909c2d88b8e17d6ea37135deff3dbd1b2480a2aef92af583/twarc-1.4.7.tar.gz"
  sha256 "ff2485dd77dc726319ed0b303a4bb36901414dd15e7a442de4f2ffedb377ae38"

  bottle do
    cellar :any_skip_relocation
    sha256 "9895adc95d40ecbad381c1bcc006e7ad33a556d3b730f9ca68c4a41215a07951" => :high_sierra
    sha256 "e6413d27941ac7b529455543f8e63adc1c1b05f678d297cdf30fcca95c6e1a51" => :sierra
    sha256 "819efb4cb496dc00bc645fc5a00f1d6003cda54316f1db8cb9c000a6d7493513" => :el_capitan
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
