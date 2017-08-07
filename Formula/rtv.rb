class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.17.1.tar.gz"
  sha256 "719c36da951e0bb7e77ed3e3efbb8b32d9045918c4af17fa7af4e334b9ebbfd9"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d403dac63fc28d6ea43f3bb7d49306865104448554efd237260789fc0acc3d20" => :sierra
    sha256 "eb9491d564913cc7b7e98e4e2f9fff5b8c68cf7edb40b856efc64948b5f5082d" => :el_capitan
    sha256 "197fd4a7a91a8ac810cf58b4c56554953a51386f4010c9cc89eae8ee0645f0c7" => :yosemite
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
