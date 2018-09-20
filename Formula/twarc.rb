class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/e1/f2/2d79badd5fab00826d5fb2a66b0d1923933ef937338edbdbdd01ae3f5181/twarc-1.6.1.tar.gz"
  sha256 "2dc79f58859ceb609a139ae90296b9eff754a2219a0b3faa6cd794d2faf6c18b"

  bottle do
    cellar :any_skip_relocation
    sha256 "55a82fc594bc557a3e71f2808baf1dc1be58b51237675ac4b4cfc177d4eca1b7" => :mojave
    sha256 "765870944fb1b726921012547894003e6f6fe9126f3aa3b57ebd032abbe67384" => :high_sierra
    sha256 "0f01fa220681de0aa5f87e4ec2eae0500e9e73d18f406f8d05d3e38fb0ef502f" => :sierra
    sha256 "b666a3a1203d44c503437b50f6f3a944a7ff93117ae74390ef2201defeb1b5d4" => :el_capitan
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
