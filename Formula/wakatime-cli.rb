class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/47/a4/3e4a4c72e4610a7ccdaa0a0706cab4c040090b84a29a27a4b3266499d7b1/wakatime-6.0.9.tar.gz"
  sha256 "fa9214ce24b9fd67054634c6d155b37bc8a46f20cfbcbc9dc206aff95e679f36"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef3926a7ac3531c132a98d5a8af730b7092b21d5e124bd9e75d4e3163b6483b" => :el_capitan
    sha256 "c600037b7da15c50cdfa6362d32cfbd369878a9601ffb2b085f526089a7558c2" => :yosemite
    sha256 "ed449f66b2fd822792a50905227e177a5ca2d1db77b90455e52344a650d051c9" => :mavericks
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
