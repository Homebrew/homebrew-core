class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/47/a4/3e4a4c72e4610a7ccdaa0a0706cab4c040090b84a29a27a4b3266499d7b1/wakatime-6.0.9.tar.gz"
  sha256 "fa9214ce24b9fd67054634c6d155b37bc8a46f20cfbcbc9dc206aff95e679f36"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5ad7e7648d0e16f16233178283302f604a4d363374b4d836533c9781399466" => :el_capitan
    sha256 "28ae37b32d2618265737576c273289e34844a05920b462c39a99714737fac7a6" => :yosemite
    sha256 "380304f8c5c4df761027081030c02d69f1a67b24f7dcdd9323b69b9c30561700" => :mavericks
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
