class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/bb/53/e80997c1b2827bb42c80964d3144a36fb93d789547f5279c4f119d5fe8cb/wakatime-6.0.8.tar.gz"
  sha256 "acb3d8bcb45d801ea05a091cb8e601395bfb8fce5ab45cef1345b3e036a29580"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3f3b67b61aeff2c4be0066205310fbe4e1d2b649c40050ff684a56673197c1e" => :el_capitan
    sha256 "571e32fb8a16d6fe31642dd1439fae768fb3eff32a8dc6baaf5cb1f6748e10ce" => :yosemite
    sha256 "bd4b142fff12125e85fa547f99dde0ed00e3401110a8a5567e8b6008d9bee08a" => :mavericks
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
