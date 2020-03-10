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
    sha256 "6696970e4ef065c0de51b1bcebcd8299ee5ef1af006f61b7b7c2826ffba1772b" => :catalina
    sha256 "b604b939703f82ad867a4a8921b1cef0745dfb45da74244d420878da0e1b2aae" => :mojave
    sha256 "d4f6689640d868afa9340d4f00dd240b3ba0529a84bfeb1c45a035215c6b2ff3" => :high_sierra
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
