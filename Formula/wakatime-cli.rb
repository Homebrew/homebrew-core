class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/42/b2/be451c7a3cdd0fd9d3d58f929420b97badacdb71342cd91d3ab1df34b390/wakatime-6.0.7.tar.gz"
  sha256 "53148943f725402448d8a3ae49cb019ce0a820cd5930e22677a77cf73553ed9b"

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
