class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.15.0.tar.gz"
  sha256 "795ac6b253445a1a76b246432393e6e5f12babba0360ed7caac33fca57ced891"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    sha256 "caf81bf92e936831f6e470438e03e1f32f1f316aee37aab32451f9702368ee4b" => :sierra
    sha256 "5d81784ae2d17212a9a6e696f492448b26967cc9b00fafc5a662d7534b7d2a53" => :el_capitan
    sha256 "5ee89f0e89733b3241795f2b867530f546cebbb75816d649843a88afcae5b641" => :yosemite
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
