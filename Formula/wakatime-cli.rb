class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/7f/1b/35af9c697d279451cffcadeb301cfe63f97ad8e50898d31182af102cdd2f/wakatime-6.2.2.tar.gz"
  sha256 "f3c4d1594506d43b36ed8ada30b0437259d4be22656c6b814f8a2e41b9f16e01"

  bottle do
    cellar :any_skip_relocation
    sha256 "d435785a77d3c964d7f600a6ad06e6778a97feeb6e248a208f912e370f44f86c" => :sierra
    sha256 "d435785a77d3c964d7f600a6ad06e6778a97feeb6e248a208f912e370f44f86c" => :el_capitan
    sha256 "d435785a77d3c964d7f600a6ad06e6778a97feeb6e248a208f912e370f44f86c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
