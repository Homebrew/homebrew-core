class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/83/79/ccc7f8ea7b2a8deb9098359bf242654f0097c3bcd6501d7a811ea6eb701d/wakatime-6.0.4.tar.gz"
  sha256 "653fbca6409f426d25388ab8e2691522c8dcad8a2817befd93533089e13fec5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2270372ab4b366db152cbc0dc77f3e51fbef287ebb1156a456f152f7f060ab54" => :el_capitan
    sha256 "e5810fb8f787cd9be980b44651d58076d9199e968b73d90cc6a618915061d5f5" => :yosemite
    sha256 "4538612e2175e482cd4ce7ee44814ba0847c8527f99b5b5385c1924353998b3d" => :mavericks
    sha256 "ddefa41fd45e9535fa7c972b22d7e264f702bf0a50f8ec93b0270199b87ea83c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec+"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
