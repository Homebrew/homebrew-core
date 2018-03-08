class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.22.0.tar.gz"
  sha256 "d76547e0567dc63ec5a0570962fbb1766cd79eed7fe4e9c51838baa481098acf"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01941fc199dee6a1c036030d06344e535060ebe524f73fed2da22ec4b775910e" => :high_sierra
    sha256 "a11a4b4c8b2a521d5c05928edf85da7aff9a05b99f63d3459a1897386481d803" => :sierra
    sha256 "647a86f510abdb11a55335eec4afadc8d60b014819dac87016067045849776ef" => :el_capitan
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
