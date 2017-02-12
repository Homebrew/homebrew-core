class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/ea/02/7eabb94699fd4c2209e2405eafe693ba53e48eddb99c926ed1d641b1243c/wakatime-6.2.1.tar.gz"
  sha256 "ad12fd298b0eb03148230f7a82395d406a5c8d50c32477b6ebe323194e189e4e"

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
