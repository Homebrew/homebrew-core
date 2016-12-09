class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/bb/62/8878ca650bb002f29aef1ecc7292954c24bfe30ecb94ec4504aff726b22d/wakatime-6.2.0.tar.gz"
  sha256 "e8eaba0dd83621b2bd4d1e71b1775ec78f65823d07ae4b1f65fa085210418b78"

  bottle do
    cellar :any_skip_relocation
    sha256 "f48b185cd7bc761201d941e85e8c8cb0dd5097090517091c0d51340e490dd35f" => :sierra
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
