class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.27.0.tar.gz"
  sha256 "c57a6cbb2525160b6aaa9180aec0293962b6969675f8ac0f2cfacff3cbd00d7c"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e615584a7b34c084ce03f1706d59040992cdadba29749c4b2cbc8a11f97d621" => :catalina
    sha256 "8ed89953d4ad5b442e9d0c70b4666d5bee9d000b770494c3362d198cedf4c333" => :mojave
    sha256 "eb6ffa91b9211cde7fd1dd705df5f22ca437240fff127f9822eb124c1b711ce8" => :high_sierra
    sha256 "1c1cd02142c41260e04a0db2fcfc659b20431fe64f4dbefa41f75216b217c137" => :sierra
  end

  depends_on "python"

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
