class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/05/ef/9dde88c03218e007e9da005195bb7318423558549d371459518dccb60adf/wakatime-6.0.6.tar.gz"
  sha256 "93156b3df829f28535f390dbc8231dd9c5bce8f54633742c264f0fd6baf8597f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f0b41dbf3f63488aa48ce9b24b73b3b5fae081b4d4dd2ee27e15453fb1119d2" => :el_capitan
    sha256 "f5d4a65155f1ff3945ff35c4d2c94fdd0f711ecab5bd71ea0812028e574402a1" => :yosemite
    sha256 "bd192fba92a79d107bdb4fc807b1d90603e24bdea2fc68b1995fda1c4b440154" => :mavericks
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
