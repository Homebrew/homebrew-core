class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.15.1.tar.gz"
  sha256 "22d824c546692833c58f95cfbf131615733af43c1e0ac2bfd7021cdbe4817818"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1150078855ce067ab06c6f2f4d8d0f6f06100f2fda505dd79b9aedd2dfbc6858" => :sierra
    sha256 "09ef6f87cc723a8c68d03ed869d86bfb0e276e5bbf82e13e082083d671446e7f" => :el_capitan
    sha256 "a91fc1311cfc804a64e2bd68cfd261cf1cec0b9cc9f0c746d79a921a42e01209" => :yosemite
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
