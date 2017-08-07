class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.17.1.tar.gz"
  sha256 "719c36da951e0bb7e77ed3e3efbb8b32d9045918c4af17fa7af4e334b9ebbfd9"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e14c39db8a5243c4e3e4f52f9e8cf78e073aa17035482697bb985238f2f0599" => :sierra
    sha256 "090c995a6d4a0b58f2e0c2db7f633e141e3794a5078785fcf4d09e952d20abac" => :el_capitan
    sha256 "d75cefe1c2bf86e5e62bd9eda6c29fdc12622c4cb923c3f8b66f89f0a1840bf7" => :yosemite
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
