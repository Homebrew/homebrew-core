class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.18.0.tar.gz"
  sha256 "44e49253db01bcda5992b80804444c6e996092146c5176a7f44ca1a1f1abe815"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f389c2b53267ce8d77b9821a2963c17ff9b2392662c856ec9986101cb0138c2" => :high_sierra
    sha256 "f7fef2336343278301ad27b10cdd4b1bdf4ff54298dc294635d91b242d5a658e" => :sierra
    sha256 "fd7e1a445f216b5d6d1c9c0b63cefe6d78201367009177dafb631ab9919fc5cb" => :el_capitan
    sha256 "1bccdfc39aeb805a13d4cae3d57c512c6f086c261ddff7220da53696bf7a25cd" => :yosemite
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
