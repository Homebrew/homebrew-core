class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.26.0.tar.gz"
  sha256 "1e3c20fdbda2a1f1b584194a36895d8e42aba527b2e9fa7be8ff7fd79c8bee85"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ab25cf624f56867c5b66e7d16a411efef1a4dcc410be85ed161326f8cfbddad" => :mojave
    sha256 "48174b1adafed3cc06d5f6f4482054d9587a2a5bff79c36a5db690b1fb8f83f9" => :high_sierra
    sha256 "0f00ccc0984e882d22d2cdff8616bb0c7eeb867f6507a8ac20f46b8d9ac21aef" => :sierra
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
