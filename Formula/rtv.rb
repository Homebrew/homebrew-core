class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.27.0.tar.gz"
  sha256 "c57a6cbb2525160b6aaa9180aec0293962b6969675f8ac0f2cfacff3cbd00d7c"
  revision 2
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcb3e97de9fc2df6b3903b0286dfd47b4599c7bbfe3e557561884b84fe1dd83b" => :catalina
    sha256 "a3c02e3552df47986bc5a0f3a92e7317fd873167b2aac429f188646994c71b9d" => :mojave
    sha256 "a12678c3f7c95c3d45c2e631fda28d1da29fd6768f8dcce235b3599f580e264b" => :high_sierra
  end

  depends_on "python@3.8"

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
