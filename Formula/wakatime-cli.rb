class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/42/b2/be451c7a3cdd0fd9d3d58f929420b97badacdb71342cd91d3ab1df34b390/wakatime-6.0.7.tar.gz"
  sha256 "53148943f725402448d8a3ae49cb019ce0a820cd5930e22677a77cf73553ed9b"

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
