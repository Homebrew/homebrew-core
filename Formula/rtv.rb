class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.20.0.tar.gz"
  sha256 "a13ab27e3b5bfb2f3f755315dcf2d2d07dd369d1fc3e01bbee2d91e42c89b2ab"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec1759494bc5c3c6133e7128678d232dcf2bac1c701633263006bed76faa4543" => :high_sierra
    sha256 "2be495dff5239620df6e2ce23d96f67954a8b99efda3b4eaae7f64c4cdd64a79" => :sierra
    sha256 "493508a19c9b93cad4fdae3c8ebb6a9d1f322fa3be5be705961fb7bab1bc57d3" => :el_capitan
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
